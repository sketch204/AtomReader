//
//  ArticleListViewModel.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

@Observable
final class ArticleListViewModel {
    private let store: Store
    var filter: ArticleFilter = .none
    
    var doesUserHaveNoFeeds: Bool {
        store.feeds.isEmpty
    }
    
    private(set) var isLoading: Bool = false
    
    var articles: [Article] {
        let output =
            switch filter {
            case .feed(let feedId):
                store.articles(for: feedId)
            case .category(let category):
                store.articles(for: category)
            case .none, .history:
                store.articles
            }
        return output.sorted(using: KeyPathComparator(\Article.publishedAt, order: .reverse))
    }
    
    init(store: Store, filter: ArticleFilter = .none) {
        self.store = store
        self.filter = filter
    }
    
    @MainActor
    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try await store.refresh()
        } catch {
            Logger.app.error("Failed to refresh store -- \(error)")
        }
    }
    
    func feed(for article: Article) -> Feed {
        store.feed(for: article) ?? .unknown
    }
}
