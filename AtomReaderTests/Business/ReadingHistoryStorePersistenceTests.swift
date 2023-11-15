//
//  ReadingHistoryStorePersistenceTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-15.
//

import XCTest
@testable import AtomReader

final class ReadingHistoryStorePersistenceTests: XCTestCase {
    func test_init_loadsArticles_whenArticlesAvailable() async {
        let manager = MockReadingHistoryStorePersistenceManager(
            articles: mockArticles
                .map({ ReadArticle(article: $0, readAt: Date()) })
        )
        let sut = ReadingHistoryStore(persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertEqual(sut.readArticles, manager.readArticles)
    }
    
    func test_markArticleRead_whenMarkingRead_saves() async {
        let manager = MockReadingHistoryStorePersistenceManager(
            articles: [mockFeed1Article1]
                .map({ ReadArticle(article: $0, readAt: Date()) })
        )
        let sut = ReadingHistoryStore(persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        sut.mark(article: mockFeed1Article2, read: true)
        
        XCTAssertEqual(manager.saveArticlesCalls.count, 1)
        XCTAssertEqual(manager.saveArticlesCalls.first?.arguments.count, 2)
    }
    
    func test_markArticleRead_whenMarkingUnread_saves() async {
        let manager = MockReadingHistoryStorePersistenceManager(
            articles: [mockFeed1Article1, mockFeed1Article2]
                .map({ ReadArticle(article: $0, readAt: Date()) })
        )
        let sut = ReadingHistoryStore(persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        sut.mark(article: mockFeed1Article2, read: false)
        
        XCTAssertEqual(manager.saveArticlesCalls.count, 1)
        XCTAssertEqual(manager.saveArticlesCalls.first?.arguments, Array(manager.readArticles.dropLast()))
    }
}

class MockReadingHistoryStorePersistenceManager: ReadingHistoryStorePersistenceManager {
    struct Call<Arguments> {
        var arguments: Arguments
    }
    
    var readArticles: [ReadArticle]
    
    private(set) var saveArticlesCalls: [Call<[ReadArticle]>] = []
    
    init(articles: [ReadArticle] = []) {
        self.readArticles = articles
    }
    
    func load() async -> [ReadArticle] {
        readArticles
    }
    
    func save(_ articles: [ReadArticle]) {
        saveArticlesCalls.append(Call(arguments: articles))
    }
}

extension MockReadingHistoryStorePersistenceManager.Call: Equatable where Arguments: Equatable {}
