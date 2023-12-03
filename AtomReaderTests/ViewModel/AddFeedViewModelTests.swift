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
}


extension AddFeedViewModelTests {
    func test_feedUrlString_whenFullFeedUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "https://hello.mock/feed"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_feedUrlString_whenPartialFeedUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "hello.mock/feed"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_feedUrlString_whenFullWebsiteUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "https://hello.mock"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_feedUrlString_whenPartialWebsiteUrlSet_fetchesPreviews() async {
        sut.feedUrlString = "hello.mock"
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.feedPreviews, [mockFeed1])
    }
    
    func test_feedUrlString_whenEmptyUrlSet_ignoresIt() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = ""
        
        try? await Task.sleep(for: .milliseconds(250))
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_feedUrlString_rightAfterChangingPreviews_resetFeeds() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        sut.feedUrlString = mockFeed3.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(300))
        
        XCTAssertEqual(sut.feedPreviews, [])
        XCTAssertEqual(sut.selectedFeeds, [])
    }
    
    func test_feedUrlString_whenFetchingFeed_selectedFeedsAutoSet() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed1.id])
    }
    
    func test_feedUrlString_afterChangingPreviews_resetSelectedFeeds() async {
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed1.id])
        
        sut.feedUrlString = mockFeed3.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed3.id])
    }
    
    func test_feedUrlString_whenErrorEncountered_errorMessageSet() async {
        struct CustomError: Error, CustomDebugStringConvertible {
            let message: String = "Unsupported"
            var localizedDescription: String { debugDescription }
            var debugDescription: String { message }
        }
        
        struct ThrowingFeedProvider: FeedPreviewerDataProvider {
            func feed(at url: URL) async throws -> Feed {
                throw CustomError()
            }
        }
        
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: ThrowingFeedProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        XCTAssertEqual(sut.errorMessage, CustomError().message)
    }
}


extension AddFeedViewModelTests {
    func test_isLoading_whenFetching_isLoadingSetCorrectly() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        XCTAssertFalse(sut.isLoading)
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(250))
        
        XCTAssertTrue(sut.isLoading)
        
        try? await Task.sleep(for: .milliseconds(400))
        
        XCTAssertFalse(sut.isLoading)
    }
}


extension AddFeedViewModelTests {
    func test_canAddFeed_whenNoPreviewsFetched_false() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        XCTAssertFalse(sut.canAddFeed)
    }
    
    func test_canAddFeed_whenPreviewsFetchedButNothingSelected_false() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        sut.selectedFeeds = []
        
        XCTAssertFalse(sut.canAddFeed)
    }
    
    func test_canAddFeed_whenPreviewsFetchedButSelectionIsAlreadyAdded_false() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed2.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        XCTAssertFalse(sut.canAddFeed)
    }
    
    func test_canAddFeed_whenPreviewsFetchedAndSelected_true() async {
        let sut = AddFeedViewModel(
            store: store,
            feedPreviewer: FeedPreviewer(
                feedProvider: DelayedDataProvider(),
                networkInterface: MockNetworkInterface()
            )
        )
        
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(600))
        
        XCTAssertTrue(sut.canAddFeed)
    }
}


extension AddFeedViewModelTests {
    func test_isFeedAlreadyAdded_whenNewFeedProvided_returnsFalse() {
        let isAdded = sut.isFeedAlreadyAdded(mockFeed1)
        XCTAssertFalse(isAdded)
    }
    
    func test_isFeedAlreadyAdded_whenExistingFeedProvided_returnsTrue() {
        let isAdded = sut.isFeedAlreadyAdded(mockFeed2)
        XCTAssertTrue(isAdded)
    }
}


extension AddFeedViewModelTests {
    func test_addFeeds_whenFeedsSelected_addsFeeds() async {
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(500))
        
        sut.selectedFeeds = [mockFeed1.id]
        sut.addFeeds()
        
        XCTAssertEqual(store.feeds, [mockFeed2, mockFeed1])
    }
    
    func test_addFeeds_whenNoFeedsSelected_noChangesMade() {
        sut.addFeeds()
        
        XCTAssertEqual(store.feeds, [mockFeed2])
    }
    
    func test_addFeeds_whenNonExistedFeedSelected_ignoresIt() async {
        sut.feedUrlString = mockFeed1.feedUrl.absoluteString
        
        try? await Task.sleep(for: .milliseconds(500))
        
        sut.setFeed(mockFeed3, selected: true)
        
        sut.addFeeds()
        
        XCTAssertEqual(store.feeds, [mockFeed2, mockFeed1])
    }
}


extension AddFeedViewModelTests {
    func test_isFeedSelected_whenNonExistedFeedPrompted_false() {
        sut.selectedFeeds = []
        
        XCTAssertFalse(sut.isFeedSelected(mockFeed1))
    }
    
    func test_isFeedSelected_whenNonSelectedFeedPrompted_false() {
        sut.selectedFeeds = [mockFeed2.id]
        
        XCTAssertFalse(sut.isFeedSelected(mockFeed1))
    }
    
    func test_isFeedSelected_whenSelectedFeedPrompted_true() {
        sut.selectedFeeds = [mockFeed1.id]
        
        XCTAssertTrue(sut.isFeedSelected(mockFeed1))
    }
}


extension AddFeedViewModelTests {
    func test_toggleFeedSelection_whenNonSelectedFeedPassed_makesItSelected() {
        sut.selectedFeeds = []
        
        sut.toggleFeedSelection(mockFeed1)
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed1.id])
    }
    
    func test_toggleFeedSelection_whenSelectedFeedPassed_makesItNotSelected() {
        sut.selectedFeeds = [mockFeed1.id]
        
        sut.toggleFeedSelection(mockFeed1)
        
        XCTAssertEqual(sut.selectedFeeds, [])
    }
}

extension AddFeedViewModelTests {
    func test_setFeedSelected_whenSelectingNonSelected_makesItSelected() {
        sut.selectedFeeds = []
        
        sut.setFeed(mockFeed1, selected: true)
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed1.id])
    }
    
    func test_setFeedSelected_whenUnselectingNonSelected_() {
        sut.selectedFeeds = []
        
        sut.setFeed(mockFeed1, selected: false)
        
        XCTAssertEqual(sut.selectedFeeds, [])
    }
    
    func test_setFeedSelected_whenSelectingSelected_keepsItNotUnselected() {
        sut.selectedFeeds = [mockFeed1.id]
        
        sut.setFeed(mockFeed1, selected: true)
        
        XCTAssertEqual(sut.selectedFeeds, [mockFeed1.id])
    }
    
    func test_setFeedSelected_whenUnselectingSelected_makesItUnselected() {
        sut.selectedFeeds = [mockFeed1.id]
        
        sut.setFeed(mockFeed1, selected: false)
        
        XCTAssertEqual(sut.selectedFeeds, [])
    }
}
