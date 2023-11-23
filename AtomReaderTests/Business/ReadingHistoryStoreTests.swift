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
    func test_markArticlesRead_whenNewArticlesRead_setRecentDateForNewReadArticle() throws {
        let sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1])
        let newArticle1 = mockFeed1Article2
        let newArticle2 = mockFeed2Article1
        
        let dateBeforeAdd = Date()
        sut.mark(articles: [newArticle1, newArticle2], read: true)
        
        let article1 = try XCTUnwrap(sut.readArticles.first(where: { $0.article == newArticle1 }))
        XCTAssertEqual(
            article1.readAt.timeIntervalSinceReferenceDate,
            dateBeforeAdd.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
        
        let article2 = try XCTUnwrap(sut.readArticles.first(where: { $0.article == newArticle2 }))
        XCTAssertEqual(
            article2.readAt.timeIntervalSinceReferenceDate,
            dateBeforeAdd.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
    }
    
    func test_markArticlesRead_whenNewArticleRead_addsToReadArticles() {
        let sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1])
        let newArticle1 = mockFeed1Article2
        let newArticle2 = mockFeed2Article1
        
        sut.mark(articles: [newArticle1, newArticle2], read: true)
        
        let readArticles = Set(sut.readArticles.map(\.article))
        let expectedArticles = Set([newArticle1, newArticle2, mockFeed1Article1])
        
        XCTAssertEqual(readArticles, expectedArticles)
    }
    
    func test_markArticlesRead_whenAlreadyReadArticleRead_resetReadAt() throws {
        let sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1, mockReadFeed2Article1])
        let newArticle = mockFeed1Article2
        let alreadyReadArticle = mockFeed2Article1
        
        let dateBeforeAdd = Date()
        sut.mark(articles: [newArticle, alreadyReadArticle], read: true)
        
        XCTAssertTrue(sut.readArticles.contains(where: { $0.article == newArticle }))
        
        let readArticle = try XCTUnwrap(sut.readArticles.first(where: { $0.article == alreadyReadArticle }))
        XCTAssertEqual(
            readArticle.readAt.timeIntervalSinceReferenceDate,
            dateBeforeAdd.timeIntervalSinceReferenceDate,
            accuracy: 1
        )
    }
    
    func test_markArticlesRead_whenNewArticleUnread_makesNoChanges() {
        let sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1])
        let newArticle1 = mockFeed1Article2
        let newArticle2 = mockFeed2Article1
        
        sut.mark(articles: [newArticle1, newArticle2], read: false)
        
        let readArticles = Set(sut.readArticles.map(\.article))
        let expectedArticles = Set([mockFeed1Article1])
        
        XCTAssertEqual(readArticles, expectedArticles)
    }
    
    func test_markArticlesRead_whenAlreadyReadArticleUnread_removesFromReadArticles() {
        let sut = ReadingHistoryStore(readArticles: [mockReadFeed1Article1, mockReadFeed2Article1])
        let newArticle = mockFeed1Article2
        let alreadyReadArticle = mockFeed2Article1
        
        sut.mark(articles: [newArticle, alreadyReadArticle], read: false)
        
        let readArticles = Set(sut.readArticles.map(\.article))
        let expectedArticles = Set([mockFeed1Article1])
        
        XCTAssertEqual(readArticles, expectedArticles)
    }
    
    func test_markArticlesRead_whenNoArticlesProvided_makesNoChange() {
        let articlesBeforeChange = sut.readArticles
        
        sut.mark(articles: [], read: true)
        XCTAssertEqual(sut.readArticles, articlesBeforeChange)
        
        sut.mark(articles: [], read: false)
        XCTAssertEqual(sut.readArticles, articlesBeforeChange)
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
