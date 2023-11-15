//
//  ReadingHistoryStore.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import Foundation

protocol ReadingHistoryStorePersistenceManager {
    func load() async -> [ReadArticle]
    
    func save(_ articles: [ReadArticle])
}

@Observable
final class ReadingHistoryStore {
    private(set) var readArticles: [ReadArticle] = []
    
    private var persistenceManager: ReadingHistoryStorePersistenceManager?
    
    init(readArticles: [ReadArticle]) {
        self.readArticles = readArticles
    }
    
    init(persistenceManager: ReadingHistoryStorePersistenceManager) {
        self.persistenceManager = persistenceManager
        
        Task {
            readArticles = await persistenceManager.load()
        }
    }
}

extension ReadingHistoryStore {
    func mark(article: Article, read: Bool) {
        if let index = readArticles.firstIndex(where: { $0.id == article.id }) {
            readArticles.remove(at: index)
        }
        
        if read {
            readArticles.append(ReadArticle(article: article, readAt: Date()))
        }
        
        persistenceManager?.save(readArticles)
    }
}

extension ReadingHistoryStore {
    func isArticleRead(_ article: Article) -> Bool {
        readArticles.contains(where: { $0.article == article })
    }
}
