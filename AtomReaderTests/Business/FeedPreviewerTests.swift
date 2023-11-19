//
//  FeedPreviewerTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-19.
//

import XCTest
@testable import AtomReader

final class FeedPreviewerTests: XCTestCase {
    var sut: FeedPreviewer!
    
    override func setUp() {
        sut = FeedPreviewer(
            feedProvider: MockDataProvider(),
            networkInterface: MockNetworkInterface()
        )
    }
    
    func test_previewFeeds_whenFeedUrlProvided_parsesFeed() async throws {
        let feeds = try await sut.previewFeeds(at: mockFeed1.feedUrl)
        let expectedFeeds = [mockFeed1]
        
        XCTAssertEqual(feeds, expectedFeeds)
    }
    
    func test_previewFeeds_whenWebsiteUrlProvided_parsesFeed() async throws {
        let feeds = try await sut.previewFeeds(at: mockFeed1.websiteUrl)
        let expectedFeeds = [mockFeed1]
        
        XCTAssertEqual(feeds, expectedFeeds)
    }
}


