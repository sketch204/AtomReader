//
//  ArticleListViewModelTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-12.
//

import XCTest
@testable import AtomReader

final class ArticleListViewModelTests: XCTestCase {
    var sut: ArticleListViewModel!
    
    override func setUp() {
        sut = ArticleListViewModel(store: makeTestStore())
    }
    
    func test_whenFilterIsNone_allArticlesReturned() {
        sut.filter = .none
        
        XCTAssertEqual(sut.articles, mockArticles)
    }
    
    func test_whenFilterIsSet_onlyFeedArticlesReturned() {
        sut.filter = .feed(mockFeed1.id)
        
        XCTAssertEqual(sut.articles, mockFeed1Articles)
    }
}

extension ArticleListViewModelTests {
    func test_whenRefreshing_isLoadingIsSetAppropriately() async {
        let sut = ArticleListViewModel(
            store: makeTestStore(
                dataProvider: DelayedDataProvider()
            )
        )
        
        // Start off without loading
        XCTAssertFalse(sut.isLoading)
        
        // Queue a check for while the store is refreshing
        Task {
            try? await Task.sleep(for: .milliseconds(50))
            // Once refreshing, should be loading
            XCTAssertTrue(sut.isLoading)
        }
        
        await sut.refresh()
        
        // Once finished, should not be loading
        XCTAssertFalse(sut.isLoading)
    }
}
