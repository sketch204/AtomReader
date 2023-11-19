//
//  AddFeedViewModel.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

import Foundation
import Combine

@MainActor
@Observable
final class AddFeedViewModel {
    private let store: Store
    private let feedPreviewer: FeedPreviewer
    
    var feedUrlString: String {
        get {
            access(keyPath: \.feedUrlString)
            return feedUrlStringSubject.value
        }
        set {
            withMutation(keyPath: \.feedUrlString) {
                feedUrlStringSubject.send(newValue)
            }
        }
    }
    var isLoading: Bool {
        previewsTask != nil
    }
    var selectedFeeds: Set<Feed.ID> = []
    private(set) var feedPreviews: [Feed] = []
    
    private var previewsTask: Task<Void, Never>?
    private var subscriptions = Set<AnyCancellable>()
    
    private let feedUrlStringSubject = CurrentValueSubject<String, Never>("")
    
    init(store: Store, feedPreviewer: FeedPreviewer) {
        self.store = store
        self.feedPreviewer = feedPreviewer
        
        registerPublishers()
    }
    
    private func registerPublishers() {
        feedUrlStringSubject
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap(url(from:))
            .sink { [weak self] feedUrl in
                self?.previewFeeds(at: feedUrl)
            }
            .store(in: &subscriptions)
    }
    
    private func url(from string: String) -> URL? {
        if string.hasPrefix("http") {
            URL(string: string)
        } else {
            URL(string: "https://\(string)")
        }
    }
}

extension AddFeedViewModel {
    private func previewFeeds(at url: URL) {
        previewsTask?.cancel()
        previewsTask = Task {
            do {
                try await previewFeeds(at: url)
            } catch {
                Logger.app.critical("Failed to load feed previews at \(url) -- \(error)")
            }
            
            if !Task.isCancelled {
                previewsTask = nil
            }
        }
    }
    
    private func previewFeeds(at url: URL) async throws {
        let feeds = try await feedPreviewer.previewFeeds(at: url)
        guard !Task.isCancelled else { return }
        feedPreviews = feeds
        selectedFeeds = Set(feeds.map(\.id))
    }
}

extension AddFeedViewModel {
    func addFeeds() {
        let feeds = feedPreviews.filter({ selectedFeeds.contains($0.id) })
        
        store.addFeeds(feeds)
    }
    
    func isFeedAlreadyAdded(_ feed: Feed) -> Bool {
        store.feed(for: feed.id) != nil
    }
}
