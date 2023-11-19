//
//  AddFeedViewModelTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-18.
//

import XCTest
@testable import AtomReader

@MainActor
final class AddFeedViewModelTests: XCTestCase {
    let store = makeTestStore(feeds: [mockFeed2])
    var sut: AddFeedViewModel!
    
    override func setUp() {
        sut = AddFeedViewModel(
            store: store,
            feedPreviewer: makeTestFeedPreviewer()
        )
    }
    
    func test_previewFeedFetching_whenFullFeedUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "https://hello.mock/feed"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_previewFeedFetching_whenPartialFeedUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "hello.mock/feed"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_previewFeedFetching_whenFullWebsiteUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "https://hello.mock"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_previewFeedFetching_whenPartialWebsiteUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "hello.mock"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_previewFeedFetching_whenFetching_setIsLoadingCorrectly() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        XCTAssertFalse(sut.isLoading)
        
        sut.feedUrlString = "https://hello.mock/feed"
        
        try? await Task.sleep(for: .milliseconds(250))
        
        XCTAssertTrue(sut.isLoading)
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_isFeedAlreadyAdded_whenNewFeedProvided_returnsFalse() {
        let isAdded = sut.isFeedAlreadyAdded(mockFeed1)
        XCTAssertFalse(isAdded)
    }
    
    func test_isFeedAlreadyAdded_whenExistingFeedProvided_returnsTrue() {
        let isAdded = sut.isFeedAlreadyAdded(mockFeed2)
        XCTAssertTrue(isAdded)
    }
    
    func test_addFeeds_addsFeeds() {
        sut.addFeeds([mockFeed1])
        
        XCTAssertEqual(store.feeds, [mockFeed2, mockFeed1])
    }
}
