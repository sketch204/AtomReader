//
//  StoreTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader

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
