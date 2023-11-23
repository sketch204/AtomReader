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
    
    func test_addFeeds_whenAddingEmpty_doesNothing() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed2]
        )
        
        sut.addFeeds([])
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2])
    }
    
    func test_addFeeds_whenAddingFeeds_addsFeeds() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1]
        )
        
        sut.addFeeds([mockFeed2, mockFeed3])
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2, mockFeed3])
    }
    
    func test_addFeeds_whenAddingExistingFeeds_ignoresDuplicates() {
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [mockFeed1, mockFeed3]
        )
        
        sut.addFeeds([mockFeed2, mockFeed3])
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed3, mockFeed2])
    }
    
    func test_addFeeds_whenAddingExistingFeedsWithNameOverride_ignoresDuplicates() {
        var feed1 = mockFeed1
        feed1.nameOverride = "Name Override"
        let sut = Store(
            dataProvider: MockDataProvider(),
            feeds: [feed1, mockFeed3]
        )
        
        sut.addFeeds([mockFeed2, mockFeed1])
        
        XCTAssertEqual(sut.feeds, [feed1, mockFeed3, mockFeed2])
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
    
    func test_refreshFeeds_preservesOldNameOverrides() async throws {
        let nameOverride = "Some custom name"
        var oldFeed = mockFeed1Old
        oldFeed.nameOverride = nameOverride
        let sut = Store(dataProvider: MockDataProvider(), feeds: [oldFeed])
        
        try await sut.refreshFeeds()
        
        var expectedFeed = mockFeed1
        expectedFeed.nameOverride = nameOverride
        
        XCTAssertEqual(sut.feeds, [expectedFeed])
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
    
    func test_addFeeds_refreshesArticles() async {
        let sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeeds([mockFeed2, mockFeed3])
        
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
    func test_feedForId_whenExistingFeedProvided_findsFeed() {
        let sut = makeTestStore()
        
        let feed = sut.feed(for: mockFeed1.id)
        
        XCTAssertEqual(feed, mockFeed1)
    }
    
    func test_feedForId_whenNonExistingFeedProvided_returnsNil() {
        let sut = makeTestStore()
        
        let feed = sut.feed(
            for: Feed.ID(
                feedUrl: URL(string: "non-existent")!
            )
        )
        
        XCTAssertNil(feed)
    }
    
    func test_feedForArticle_whenArticleProvided_returnsCorrectFeed() {
        let sut = makeTestStore()
        
        let feed = sut.feed(for: mockFeed2Article1)
        
        XCTAssertEqual(feed, mockFeed2)
    }
    
    func test_feedForArticle_whenArticleFromNonExistentFeedProvided_returnsNil() {
        let sut = makeTestStore()
        
        let article = Article(
            title: "Title",
            summary: nil,
            articleUrl: URL(string: "non-existent")!,
            publishedAt: Date(),
            authors: [],
            feedId: Feed.ID(feedUrl: URL(string: "non-existent")!)
        )
        let feed = sut.feed(for: article)
        
        XCTAssertNil(feed)
    }
}

extension StoreTests {
    func test_renameFeed_whenRenamingNonExistentFeed_makesNoChange() {
        let sut = makeTestStore()
        
        let feedId = Feed.ID(feedUrl: URL(string: "non-existent")!)
        sut.rename(feedId: feedId, to: "some name")
        
        XCTAssertEqual(sut.feeds, mockFeeds)
    }
    
    func test_renameFeed_whenRenamingExistingFeedWithName_renamesFeed() {
        let sut = makeTestStore()
        let newName = "Mock feed 1 new name"
        
        sut.rename(feedId: mockFeed1.id, to: newName)
        var expectedFeed = mockFeed1
        expectedFeed.nameOverride = newName
        
        XCTAssertEqual(sut.feeds.first(where: { $0.id == mockFeed1.id }), expectedFeed)
    }
    
    func test_renameFeed_whenRenamingExistingFeedWithNil_resetFeedName() {
        var renamedFeed = mockFeed1
        renamedFeed.nameOverride = "Mock feed 1 new name"
        
        let sut = makeTestStore(feeds: [renamedFeed, mockFeed2])
        
        sut.rename(feedId: mockFeed1.id, to: nil)
        
        XCTAssertEqual(sut.feeds.first(where: { $0.id == mockFeed1.id }), mockFeed1)
    }
    
    func test_renameFeed_whenRenamingExistingFeedWithEmptyString_resetFeedName() {
        var renamedFeed = mockFeed1
        renamedFeed.nameOverride = "Mock feed 1 new name"
        
        let sut = makeTestStore(feeds: [renamedFeed, mockFeed2])
        
        sut.rename(feedId: mockFeed1.id, to: "")
        
        XCTAssertEqual(sut.feeds.first(where: { $0.id == mockFeed1.id }), mockFeed1)
    }
}
