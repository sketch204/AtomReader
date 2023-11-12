//
//  StoreTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader

final class StoreTests: XCTestCase {
    func test_addFeed_whenEmpty_addsFeed() {
        let sut = Store(dataProvider: MockDataProvider())
        
        sut.addFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
    
    func test_addFeed_whenNonEmpty_addsFeed() {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeed(mockFeed2)
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2])
    }
    
    func test_addFeed_whenAddingExistingFeed_doesNothing() {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
    
    func test_removeFeed_whenNonEmpty_removesFeed() {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.removeFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [])
    }
    
    func test_removeFeed_whenEmpty_doesNothing() {
        let sut = Store(dataProvider: MockDataProvider())
        
        sut.removeFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [])
    }
}

extension StoreTests {
    func test_addFeedAt_whenAddingFeedWithURL_addsFeed() async throws {
        let sut = Store(dataProvider: MockDataProvider())
        
        let url = mockFeed1.feedUrl
        try await sut.addFeed(at: url)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
}

extension StoreTests {
    func test_refreshFeeds_pullsNewFeeds() async throws {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1Old])
        
        try await sut.refreshFeeds()
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
    
    func test_refreshArticles_pullsNewArticles() async throws {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        try await sut.refreshArticles()
        
        XCTAssertEqual(sut.articles, [mockFeed1Article1, mockFeed1Article2])
    }
    
    func test_refresh_pullsNewFeedsAndArticles() async throws {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1Old])
        
        try await sut.refresh()
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
        XCTAssertEqual(sut.articles, [mockFeed1Article1, mockFeed1Article2])
    }
}

extension StoreTests {
    func test_addFeed_refreshesArticles() async {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeed(mockFeed2)
        
        try? await Task.sleep(for: .milliseconds(100))
        
        XCTAssertEqual(sut.articles, [mockFeed1Article1, mockFeed1Article2, mockFeed2Article1])
    }
    
    func test_removeFeed_removesArticles() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2],
            articles: [mockFeed1Article1, mockFeed1Article2, mockFeed2Article1]
        )
        
        sut.removeFeed(mockFeed1)
        
        XCTAssertEqual(sut.articles, [mockFeed2Article1])
    }
}

extension StoreTests {
    func test_moveFeeds_whenNonEmptySourceOffsets_moves() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2, mockFeed3]
        )
        
        sut.moveFeeds(at: IndexSet(integer: 1), to: 0)
        
        XCTAssertEqual(sut.feeds, [mockFeed2, mockFeed1, mockFeed3])
    }
    
    func test_moveFeeds_whenEmptySourceOffsets_noChangesMade() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2, mockFeed3]
        )
        
        sut.moveFeeds(at: IndexSet(), to: 0)
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2, mockFeed3])
    }
}

extension StoreTests {
    func test_removeFeedsAtOffsets_whenNonEmptyOffsets_removesFeeds() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2, mockFeed3]
        )
        
        sut.removeFeeds(at: IndexSet(integer: 1))
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed3])
    }
    
    func test_removeFeedsAtOffsets_whenNonEmptyOffsets_removesArticles() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2, mockFeed3],
            articles: [mockFeed1Article1, mockFeed1Article2, mockFeed2Article1]
        )
        
        sut.removeFeeds(at: IndexSet(integer: 1))
        
        XCTAssertEqual(sut.articles, [mockFeed1Article1, mockFeed1Article2])
    }
    
    func test_removeFeedsAtOffsets_whenEmptyOffsets_noChangesMade() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2, mockFeed3]
        )
        
        sut.removeFeeds(at: IndexSet())
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2, mockFeed3])
    }
}

extension StoreTests {
    func test_feedForArticle_whenArticleProvided_returnsCorrectFeed() {
        let sut = makeTestStore()
        
        let feed = sut.feed(for: mockFeed2Article1)
        
        XCTAssertEqual(feed, mockFeed2)
    }
}
