//
//  Store.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

protocol StoreDataProvider {
    func feed(at url: URL) async throws -> Feed
}

protocol StorePersistenceManager {
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
        persistenceManager: StorePersistenceManager? = nil,
        feeds: [Feed] = [],
        articles: [Article] = []
    ) {
        self.feeds = feeds
        self.articles = articles
        self.dataProvider = dataProvider
        self.persistenceManager = persistenceManager
    }
}

extension Store {
    func addFeed(_ feed: Feed) {
        guard !feeds.contains(where: { $0.id == feed.id }) else { return }
        feeds.append(feed)
        persistenceManager?.save(feeds)
    }
    
    func removeFeed(_ feed: Feed) {
        feeds.removeAll(where: { $0.id == feed.id })
        persistenceManager?.save(feeds)
    }
}

extension Store {
    func addFeed(at url: URL) async throws {
        let feed = try await dataProvider.feed(at: url)
        addFeed(feed)
    }
}
