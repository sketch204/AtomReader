//
//  ReadingHistoryStoreTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-15.
//

import XCTest
@testable import AtomReader

final class ReadingHistoryStoreTests: XCTestCase {
    var sut: ReadingHistoryStore!
    
    let mockReadFeed1Article1 = ReadArticle(
        article: mockFeed1Article1,
        readAt: Date()
    )
    let mockReadFeed2Article1 = ReadArticle(
        article: mockFeed2Article1,
        readAt: Date()
    )
    
    override func setUp() {
        sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1, mockReadFeed2Article1])
    }
}

extension ReadingHistoryStoreTests {
    func test_markArticleRead_whenNewArticleRead_setRecentDateForNewReadArticle() throws {
        let newArticle = mockFeed1Article2
        
        let dateBeforeAdd = Date()
        sut.mark(article: newArticle, read: true)
        
        let article = try XCTUnwrap(sut.readArticles.first(where: { $0.article == newArticle }))
        XCTAssertEqual(
            article.readAt.timeIntervalSinceReferenceDate,
            dateBeforeAdd.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
    }
    
    func test_markArticleRead_whenNewArticleRead_addsToReadArticles() {
        let newArticle = mockFeed1Article2
        
        sut.mark(article: newArticle, read: true)
        
        XCTAssertTrue(sut.readArticles.contains(where: { $0.article == newArticle }))
        XCTAssertTrue(sut.readArticles.contains(mockReadFeed1Article1))
        XCTAssertTrue(sut.readArticles.contains(mockReadFeed2Article1))
    }
    
    func test_markArticleRead_whenAlreadyReadArticleRead_resetReadAt() throws {
        let newArticle = mockFeed1Article1
        
        let dateBeforeAdd = Date()
        sut.mark(article: newArticle, read: true)
       
        let article = try XCTUnwrap(sut.readArticles.first(where: { $0.article == newArticle }))
        XCTAssertEqual(
            article.readAt.timeIntervalSinceReferenceDate,
            dateBeforeAdd.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
        XCTAssertTrue(sut.readArticles.contains(mockReadFeed2Article1))
    }
    
    func test_markArticleRead_whenNewArticleUnread_makesNoChanges() {
        let newArticle = mockFeed1Article2
        
        sut.mark(article: newArticle, read: false)
       
        XCTAssertEqual(sut.readArticles, [mockReadFeed1Article1, mockReadFeed2Article1])
    }
    
    func test_markArticleRead_whenAlreadyReadArticleUnread_removesFromReadArticles() {
        let newArticle = mockFeed1Article1
        
        sut.mark(article: newArticle, read: false)
       
        XCTAssertEqual(sut.readArticles, [mockReadFeed2Article1])
    }
}

extension ReadingHistoryStoreTests {
    func test_isArticleRead_whenReadArticleProvided() {
        let isRead = sut.isArticleRead(mockFeed1Article1)
        
        XCTAssertTrue(isRead)
    }
    
    func test_isArticleRead_whenUnreadArticleProvided() {
        let isRead = sut.isArticleRead(mockFeed1Article2)
        
        XCTAssertFalse(isRead)
    }
}
