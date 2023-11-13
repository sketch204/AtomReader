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
        guard !feeds.contains(where: { $0.id == feed.id }) else { return }
        feeds.append(feed)
        persistenceManager?.save(feeds)
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
        feeds.removeAll(where: { $0.id == feed.id })
        articles.removeAll(where: { $0.feedId == feed.id })
        persistenceManager?.save(feeds)
        persistenceManager?.save(articles)
    }
    
    func removeFeeds(at offsets: IndexSet) {
        let removedFeedIds = Set(offsets.map({ feeds[$0].id }))
        feeds.remove(atOffsets: offsets)
        articles.removeAll(where: { removedFeedIds.contains($0.feedId) })
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
        var feeds = [Feed]()
        for feed in self.feeds {
            feeds.append(try await dataProvider.feed(at: feed.feedUrl))
        }
        self.feeds = feeds
        persistenceManager?.save(feeds)
    }
    
    func refreshArticles() async throws {
        var articles = [Article]()
        for feed in self.feeds {
            articles.append(contentsOf: try await dataProvider.articles(for: feed))
        }
        self.articles = articles
        persistenceManager?.save(articles)
    }
    
    func refresh() async throws {
        try await refreshFeeds()
        try await refreshArticles()
    }
}

extension Store {
    func feed(for article: Article) -> Feed {
        guard let output = feeds.first(where: { $0.id == article.feedId }) else {
            fatalError("An article belongs to a non-existent feed")
        }
        return output
    }
}
