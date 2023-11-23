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
        mark(articles: [article], read: read)
    }
    
    func mark(articles: some Sequence<Article>, read: Bool) {
        let offsets = readArticles
            .enumerated()
            .filter({ item in
                articles.contains(where: { articleToBeMarked in
                    articleToBeMarked.id == item.element.id
                })
            })
            .map(\.offset)
        
        readArticles.remove(atOffsets: IndexSet(offsets))
        
        if read {
            let readAt = Date()
            readArticles.append(
                contentsOf: articles.map({ ReadArticle(article: $0, readAt: readAt) })
            )
        }
        
        persistenceManager?.save(readArticles)
    }
}

extension ReadingHistoryStore {
    func clear() {
        readArticles.removeAll()
        
        persistenceManager?.save(readArticles)
    }
}

extension ReadingHistoryStore {
    func isArticleRead(_ article: Article) -> Bool {
        readArticles.contains(where: { $0.article == article })
    }
}
