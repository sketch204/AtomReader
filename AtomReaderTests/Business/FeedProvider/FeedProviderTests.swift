//
//  FeedProviderTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader
@testable import AtomParser

final class FeedProviderTests: XCTestCase {
    var sut: FeedProvider!
    
    override func setUp() {
        sut = FeedProvider(networkInterface: MockNetworkInterface())
    }
    
    func test_feedAt_returnsFeed() async throws {
        let feed = try await sut.feed(at: mockFeed1.feedUrl)
        
        XCTAssertEqual(feed, mockFeed1)
    }
    
    func test_articleFor_returnsArticles() async throws {
        let articles = try await sut.articles(for: mockFeed1)
        
        XCTAssertEqual(articles, [mockFeed1Article1, mockFeed1Article2])
    }
}
