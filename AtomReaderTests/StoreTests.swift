//
//  StoreTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader

private let mockFeedUrl1 = URL(string: "https://hello.mock")!
private let mockFeedUrl2 = URL(string: "https://goobye.mock")!
private let mockFeed1 = Feed(
    name: "Hello Feed",
    description: "Feed for hello",
    iconUrl: nil,
    websiteUrl: mockFeedUrl1,
    atomFeedUrl: mockFeedUrl1
)
private let mockFeed2 = Feed(
    name: "Goodbye Feed",
    description: "Feed for goodbye",
    iconUrl: nil,
    websiteUrl: mockFeedUrl2,
    atomFeedUrl: mockFeedUrl2
)

final class StoreTests: XCTestCase {
    var sut: Store!
    
    override func setUp() {
        sut = Store(dataProvider: MockDataProvider())
    }
    
    func test_addFeed_whenEmpty_addsFeed() {
        sut.addFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
    
    func test_addFeed_whenNonEmpty_addsFeed() {
        sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeed(mockFeed2)
        
        XCTAssertEqual(sut.feeds, [mockFeed1, mockFeed2])
    }
    
    func test_addFeed_whenAddingExistingFeed_doesNothing() {
        sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.addFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
    
    func test_removeFeed_whenNonEmpty_removesFeed() {
        sut = Store(dataProvider: MockDataProvider(), feeds: [mockFeed1])
        
        sut.removeFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [])
    }
    
    func test_removeFeed_whenEmpty_doesNothing() {
        sut.removeFeed(mockFeed1)
        
        XCTAssertEqual(sut.feeds, [])
    }
}

extension StoreTests {
    func test_addFeedAt_whenAddingFeedWithURL_addsFeed() async throws {
        try await sut.addFeed(at: mockFeedUrl1)
        
        XCTAssertEqual(sut.feeds, [mockFeed1])
    }
}


struct MockDataProvider: StoreDataProvider {
    func fetchFeed(at url: URL) async throws -> Feed {
        switch url {
        case mockFeedUrl1:
            mockFeed1
        case mockFeedUrl2:
            mockFeed2
        default:
            throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
