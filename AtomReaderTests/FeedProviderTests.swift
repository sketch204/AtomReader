//
//  FeedProviderTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import XCTest
@testable import AtomReader

final class FeedProviderTests: XCTestCase {
    var sut: FeedProvider!
    
    override func setUp() {
        sut = FeedProvider(networkInterface: MockFeedProviderNetworkInterface())
    }
    
    func test_feedAt_returnsFeed() async throws {
        let feed = try await sut.feed(at: mockFeed1.atomFeedUrl)
        
        XCTAssertEqual(feed, mockFeed1)
    }
    
    func test_articleFor_returnsArticles() async throws {
        let articles = try await sut.articles(for: mockFeed1)
        
        XCTAssertEqual(articles, [mockFeed1Article1, mockFeed1Article2])
    }
}


struct MockFeedProviderNetworkInterface: FeedProviderNetworkInterface {
    func data(from url: URL) async throws -> Data {
        switch url {
        case mockFeed1.atomFeedUrl: mockFeed1Data
        case mockFeed2.atomFeedUrl: mockFeed2Data
        default: throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
