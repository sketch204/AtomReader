//
//  Store.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

protocol StoreDataProvider {
    func feed(at url: URL) async throws -> Feed
    func articles(for feed: Feed) async throws -> [Article]
}

protocol StorePersistenceManager {
    func load() async -> (feeds: [Feed], articles: [Article])
    
    func save(_ feeds: [Feed])
    func save(_ articles: [Article])
}

@Observable
final class Store {
    private(set) var feeds: [Feed] = []
    private(set) var articles: [Article] = []
    
    var categories: [Category] {
        Set(feeds.flatMap(\.categories))
            .sorted(using: KeyPathComparator(\.rawValue))
    }
    
    private let dataProvider: StoreDataProvider
    private let persistenceManager: StorePersistenceManager?
    
    init(
        dataProvider: StoreDataProvider,
        feeds: [Feed] = [],
        articles: [Article] = []
    ) {
        self.feeds = feeds
        self.articles = articles
        self.dataProvider = dataProvider
        self.persistenceManager = nil
    }
    
    init(dataProvider: StoreDataProvider, persistenceManager: StorePersistenceManager) {
        self.dataProvider = dataProvider
        self.persistenceManager = persistenceManager
        
        Task {
            let persistedData = await persistenceManager.load()
            feeds = persistedData.feeds
            articles = persistedData.articles
        }
    }
}

extension Store {
    func addFeed(_ feed: Feed) {
        addFeeds([feed])
    }
    
    func addFeeds(_ feeds: some Sequence<Feed>) {
        let newFeeds = feeds.filter { newFeed in
            let alreadyAdded = self.feeds.contains { existingFeed in
                existingFeed.id == newFeed.id
            }
            return !alreadyAdded
        }
        
        self.feeds.append(contentsOf: newFeeds)
        persistenceManager?.save(self.feeds)
        Task {
            do {
                try await refreshArticles()
            } catch {
                Logger.app.error("Failed to refresh store -- \(error)")
            }
        }
    }
    
    func moveFeeds(at sourceOffsets: IndexSet, to targetOffset: Int) {
        feeds.move(fromOffsets: sourceOffsets, toOffset: targetOffset)
        persistenceManager?.save(feeds)
    }
    
    func removeFeed(_ feed: Feed) {
        articles.removeAll(where: { $0.feedId == feed.id })
        feeds.removeAll(where: { $0.id == feed.id })
        persistenceManager?.save(feeds)
        persistenceManager?.save(articles)
    }
    
    func removeFeeds(at offsets: IndexSet) {
        let removedFeedIds = Set(offsets.map({ feeds[$0].id }))
        articles.removeAll(where: { removedFeedIds.contains($0.feedId) })
        feeds.remove(atOffsets: offsets)
        persistenceManager?.save(feeds)
        persistenceManager?.save(articles)
    }
}

extension Store {
    func addFeed(at url: URL) async throws {
        let feed = try await dataProvider.feed(at: url)
        addFeed(feed)
    }
}

extension Store {
    func refreshFeeds() async throws {
        let newFeedMap = try await withThrowingTaskGroup(
            of: Feed.self,
            returning: [Feed.ID: Feed].self
        ) { group in
            for oldFeed in feeds {
                group.addTask { [dataProvider] in
                    var newFeed = try await dataProvider.feed(at: oldFeed.feedUrl)
                    newFeed.nameOverride = oldFeed.nameOverride
                    return newFeed
                }
            }
            
            return try await group.reduce(into: [Feed.ID: Feed]()) { partialResult, feed in
                partialResult[feed.id] = feed
            }
        }
        
        // Retains order
        feeds = feeds.map { oldFeed in
            newFeedMap[oldFeed.id] ?? oldFeed
        }
        
        persistenceManager?.save(feeds)
    }
    
    func refreshArticles() async throws {
        let newArticles = try await withThrowingTaskGroup(of: [Article].self) { group in
            for feed in feeds {
                group.addTask { [dataProvider] in
                    try await dataProvider.articles(for: feed)
                }
            }
            
            return try await group.reduce(into: [Article]()) { partialResult, articles in
                partialResult.append(contentsOf: articles)
            }
        }
        
        articles = newArticles
        persistenceManager?.save(articles)
    }
    
    func refresh() async throws {
        try await refreshFeeds()
        try await refreshArticles()
    }
}

extension Store {
    func feed(for article: Article) -> Feed? {
        feed(for: article.feedId)
    }
    
    func feed(for id: Feed.ID) -> Feed? {
        feeds.first(where: { $0.id == id })
    }
    
    func feeds(for category: Category) -> [Feed] {
        feeds.filter({ $0.categories.contains(category) })
    }
}

extension Store {
    func rename(feedId: Feed.ID, to newName: String?) {
        guard let index = feeds.firstIndex(where: { $0.id == feedId }) else { return }
        
        if newName?.isEmpty ?? true {
            feeds[index].nameOverride = nil
        } else {
            feeds[index].nameOverride = newName
        }
        persistenceManager?.save(feeds)
    }
}
