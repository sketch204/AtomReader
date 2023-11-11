//
//  StorePersistenceTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader

final class StorePersistenceTests: XCTestCase {
    func test_init_loadsFeeds_whenFeedsAvailable() async {
        let manager = MockPersistenceManager(feeds: [mockFeed1, mockFeed2])
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertEqual(sut.feeds, manager.feeds)
    }
    
    func test_addFeed_savesFeeds() async {
        let manager = MockPersistenceManager(feeds: [mockFeed1])
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        sut.addFeed(mockFeed2)
        
        XCTAssertEqual(manager.saveFeedsCalls.count, 1)
        XCTAssertEqual(manager.saveFeedsCalls.first?.arguments, [mockFeed1, mockFeed2])
    }
    
    func test_removeFeed_savesFeeds() async {
        let manager = MockPersistenceManager(feeds: [mockFeed1, mockFeed2])
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        sut.removeFeed(mockFeed2)
        
        XCTAssertEqual(manager.saveFeedsCalls.count, 1)
        XCTAssertEqual(manager.saveFeedsCalls.first?.arguments, [mockFeed1])
    }
    
    func test_removeFeed_savesArticles() async {
        let manager = MockPersistenceManager(
            feeds: [mockFeed1, mockFeed2],
            articles: [mockFeed1Article1, mockFeed1Article2, mockFeed2Article1]
        )
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        sut.removeFeed(mockFeed2)
        
        XCTAssertEqual(manager.saveArticlesCalls.count, 1)
        XCTAssertEqual(manager.saveArticlesCalls.first?.arguments, [mockFeed1Article1, mockFeed1Article2])
    }
    
    func test_refreshFeeds_savesFeeds() async throws {
        let manager = MockPersistenceManager(feeds: [mockFeed1Old])
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try await Task.sleep(for: .milliseconds(100))
        
        try await sut.refreshFeeds()
        
        XCTAssertEqual(manager.saveFeedsCalls.count, 1)
        XCTAssertEqual(manager.saveFeedsCalls.first?.arguments, [mockFeed1])
    }
    
    func test_refreshArticles_savesArticles() async throws {
        let manager = MockPersistenceManager(feeds: [mockFeed1])
        let sut = Store(dataProvider: MockDataProvider(), persistenceManager: manager)
        
        try await Task.sleep(for: .milliseconds(100))
        
        try await sut.refreshArticles()
        
        XCTAssertEqual(manager.saveArticlesCalls.count, 1)
        XCTAssertEqual(manager.saveArticlesCalls.first?.arguments, [mockFeed1Article1, mockFeed1Article2])
    }
}

class MockPersistenceManager: StorePersistenceManager {
    struct Call<Arguments> {
        var arguments: Arguments
    }
    
    var feeds: [Feed]
    var articles: [Article]
    
    private(set) var saveFeedsCalls: [Call<[Feed]>] = []
    private(set) var saveArticlesCalls: [Call<[Article]>] = []
    
    init(feeds: [Feed], articles: [Article] = []) {
        self.feeds = feeds
        self.articles = articles
    }
    
    func save(_ feeds: [Feed]) {
        saveFeedsCalls.append(Call(arguments: feeds))
    }
    
    func save(_ articles: [Article]) {
        saveArticlesCalls.append(Call(arguments: articles))
    }
}
