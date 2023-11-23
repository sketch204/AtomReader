//
//  FeedProviderAtomParsingTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-13.
//

import XCTest
@testable import AtomReader
@testable import AtomParser

final class FeedProviderAtomParsingTests: XCTestCase {
    var sut: FeedProvider!
    
    override func setUp() {
        sut = FeedProvider(networkInterface: MockNetworkInterface())
    }
    
    func test_feedFrom_whenNoImageProvided_parses() throws {
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            websiteUrl: "https://hello.mock"
        )
        
        let feed = try sut.feed(from: atom, feedUrl: URL(string: "https://hello.mock/feed")!)
        let expectedFeed = Feed(
            name: "A title",
            description: "A description",
            iconUrl: nil,
            websiteUrl: URL(string: "https://hello.mock")!,
            feedUrl: URL(string: "https://hello.mock/feed")!
        )
        
        XCTAssertEqual(feed, expectedFeed)
    }
    
    func test_feedFrom_whenImageProvided_parses_resolvesImagePathToUrl() throws {
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            iconPath: "/icon",
            websiteUrl: "https://hello.mock"
        )
        
        let feed = try sut.feed(from: atom, feedUrl: URL(string: "https://hello.mock/feed")!)
        let expectedFeed = Feed(
            name: "A title",
            description: "A description",
            iconUrl: URL(string: "https://hello.mock/icon")!,
            websiteUrl: URL(string: "https://hello.mock")!,
            feedUrl: URL(string: "https://hello.mock/feed")!
        )
        
        XCTAssertEqual(feed, expectedFeed)
    }
    
    func test_feedFrom_whenWebsiteUrlMissing_doesNotParse() throws {
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            iconPath: "/icon",
            websiteUrl: nil
        )
        
        XCTAssertThrowsError(
            try sut.feed(from: atom, feedUrl: URL(string: "https://hello.mock/feed")!)
        )
    }

    func test_articlesFrom_whenAllFieldsProvided_parses() {
        let feedUrl = URL(string: "https://hello.mock")!
        let publishedAt1 = Date()
        let publishedAt2 = Date()
        
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            websiteUrl: "https://hello.mock",
            entries: [
                atomEntry(
                    title: "Entry 1",
                    summary: "Entry 1 Description",
                    articleUrl: "https://hello.mock/1",
                    publishedAt: publishedAt1,
                    updatedAt: Date(),
                    authors: ["Author"]
                ),
                atomEntry(
                    title: "Entry 2",
                    summary: "Entry 2 Description",
                    articleUrl: "https://hello.mock/2",
                    publishedAt: publishedAt2,
                    updatedAt: Date(),
                    authors: ["Author"]
                ),
            ]
        )
        
        let articles = sut.articles(from: atom, feedUrl: feedUrl)
        let expectedArticles = [
            Article(
                title: "Entry 1",
                summary: "Entry 1 Description",
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishedAt1,
                authors: ["Author"],
                feedId: Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
            ),
            Article(
                title: "Entry 2",
                summary: "Entry 2 Description",
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishedAt2,
                authors: ["Author"],
                feedId: Feed.ID(feedUrl: feedUrl)
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenRequiredFieldsProvided_parses() {
        let feedUrl = URL(string: "https://hello.mock")!
        let publishedAt1 = Date()
        let publishedAt2 = Date()
        
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            websiteUrl: "https://hello.mock",
            entries: [
                atomEntry(
                    title: "Entry 1",
                    summary: nil,
                    articleUrl: "https://hello.mock/1",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: []
                ),
                atomEntry(
                    title: "Entry 2",
                    summary: nil,
                    articleUrl: "https://hello.mock/2",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: []
                ),
            ]
        )
        
        let articles = sut.articles(from: atom, feedUrl: feedUrl)
        let expectedArticles = [
            Article(
                title: "Entry 1",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishedAt1,
                authors: [],
                feedId: Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
            ),
            Article(
                title: "Entry 2",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishedAt2,
                authors: [],
                feedId: Feed.ID(feedUrl: feedUrl)
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenNoPublishedDate_usesUpdatedAtDate() {
        let feedUrl = URL(string: "https://hello.mock")!
        let publishedAt1 = Date()
        let publishedAt2 = Date()
        
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            websiteUrl: "https://hello.mock",
            entries: [
                atomEntry(
                    title: "Entry 1",
                    summary: "Entry 1 Description",
                    articleUrl: "https://hello.mock/1",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: ["Author"]
                ),
                atomEntry(
                    title: "Entry 2",
                    summary: "Entry 2 Description",
                    articleUrl: "https://hello.mock/2",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: ["Author"]
                ),
            ]
        )
        
        let articles = sut.articles(from: atom, feedUrl: feedUrl)
        let expectedArticles = [
            Article(
                title: "Entry 1",
                summary: "Entry 1 Description",
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishedAt1,
                authors: ["Author"],
                feedId: Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
            ),
            Article(
                title: "Entry 2",
                summary: "Entry 2 Description",
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishedAt2,
                authors: ["Author"],
                feedId: Feed.ID(feedUrl: feedUrl)
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenHtmlPresentInString_removesHtml() {
        let feedUrl = URL(string: "https://hello.mock")!
        let publishedAt1 = Date()
        let publishedAt2 = Date()
        
        let atom = atomFeed(
            title: "A title",
            description: "A description",
            websiteUrl: "https://hello.mock",
            entries: [
                atomEntry(
                    title: "Entry <i>1</i>",
                    summary: "<p>Description 1</p>",
                    articleUrl: "https://hello.mock/1",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: []
                ),
                atomEntry(
                    title: "Entry <i>2</i>",
                    summary: "<p>Description 2</p>",
                    articleUrl: "https://hello.mock/2",
                    publishedAt: nil,
                    updatedAt: publishedAt1,
                    authors: []
                ),
            ]
        )
        
        let articles = sut.articles(from: atom, feedUrl: feedUrl)
        let expectedArticles = [
            Article(
                title: "Entry 1",
                summary: "Description 1",
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishedAt1,
                authors: [],
                feedId: Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
            ),
            Article(
                title: "Entry 2",
                summary: "Description 2",
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishedAt2,
                authors: [],
                feedId: Feed.ID(feedUrl: feedUrl)
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
}

extension FeedProviderAtomParsingTests {
    func atomFeed(
        uri: String = "https://hello.mock",
        title: String,
        description: String,
        iconPath: String? = nil,
        websiteUrl: String?,
        entries: [Entry] = []
    ) -> AtomParser.Feed {
        AtomParser.Feed(
            uri: URL(string: uri)!,
            title: Text(type: .text, content: title),
            updated: Date(),
            entries: entries,
            links: [
                websiteUrl.flatMap({
                    AtomParser.Link(
                        url: URL(string: $0)!,
                        relationship: .alternate,
                        type: nil,
                        title: nil,
                        length: 0
                    )
                }),
            ].compactMap({ $0 }),
            authors: [],
            categories: [],
            contributors: [],
            generator: nil,
            icon: iconPath.map({ AtomImage(path: $0) }),
            logo: nil,
            rights: nil,
            subtitle: Text(type: .text, content: description)
        )
    }
    
    func atomEntry(
        title: String,
        summary: String?,
        articleUrl: String,
        publishedAt: Date?,
        updatedAt: Date,
        authors: [String]
    ) -> AtomParser.Entry {
        Entry(
            uri: URL(string: articleUrl)!,
            title: Text(type: .text, content: title),
            updated: updatedAt,
            authors: authors.map({ AtomParser.Person(name: $0, uri: nil, email: nil) }),
            content: nil,
            links: [],
            summary: summary.map({ Text(type: .text, content: $0) }),
            categories: [],
            contributors: [],
            published: publishedAt,
            rights: nil,
            source: nil
        )
    }
}
