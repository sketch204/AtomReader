//
//  FeedProviderRSSParsingTests.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-13.
//

import XCTest
@testable import AtomReader
@testable import AtomParser

final class FeedProviderRSSParsingTests: XCTestCase {
    var sut: FeedProvider!
    
    override func setUp() {
        sut = FeedProvider(networkInterface: MockFeedProviderNetworkInterface())
    }
    
    func test_feedFrom_whenRssFeedWithoutImageProvided_parses() {
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            iconUrl: nil
        )
        
        let feed = sut.feed(from: rss, feedUrl: URL(string: "https://hello.mock/feed")!)
        let expectedFeed = Feed(
            name: "A channel",
            description: "A really awesome channel",
            iconUrl: nil,
            websiteUrl: URL(string: "https://hello.mock")!,
            feedUrl: URL(string: "https://hello.mock/feed")!
        )
        
        XCTAssertEqual(feed, expectedFeed)
    }
    
    func test_feedFrom_whenRssFeedWithImageProvided_parses() {
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            iconUrl: "https://hello.mock/icon.png"
        )
        
        let feed = sut.feed(from: rss, feedUrl: URL(string: "https://hello.mock/feed")!)
        let expectedFeed = Feed(
            name: "A channel",
            description: "A really awesome channel",
            iconUrl: URL(string: "https://hello.mock/icon.png")!,
            websiteUrl: URL(string: "https://hello.mock")!,
            feedUrl: URL(string: "https://hello.mock/feed")!
        )
        
        XCTAssertEqual(feed, expectedFeed)
    }
    
    func test_articlesFrom_whenAllFieldsPresent_parses() {
        let publishDate1 = Date()
        let publishDate2 = Date()
        let feedId = Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
        
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            items: [
                rssItem(
                    title: "Item 1",
                    description: "Description 1",
                    articleUrl: "https://hello.mock/1",
                    publishedAt: publishDate1,
                    author: "Author"
                ),
                rssItem(
                    title: "Item 2",
                    description: "Description 2",
                    articleUrl: "https://hello.mock/2",
                    publishedAt: publishDate2,
                    author: "Author"
                ),
            ]
        )
        
        let articles = sut.articles(from: rss, feedUrl: feedId.feedUrl)
        let expectedArticles = [
            Article(
                title: "Item 1",
                summary: "Description 1",
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishDate1,
                authors: ["Author"],
                feedId: feedId
            ),
            Article(
                title: "Item 2",
                summary: "Description 2",
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishDate2,
                authors: ["Author"],
                feedId: feedId
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenRequiredFieldsPresent_parses() {
        let publishDate1 = Date()
        let publishDate2 = Date()
        let feedId = Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
        
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            items: [
                rssItem(
                    title: "Item 1",
                    description: nil,
                    articleUrl: "https://hello.mock/1",
                    publishedAt: publishDate1,
                    author: nil
                ),
                rssItem(
                    title: "Item 2",
                    description: nil,
                    articleUrl: "https://hello.mock/2",
                    publishedAt: publishDate2,
                    author: nil
                ),
            ]
        )
        
        let articles = sut.articles(from: rss, feedUrl: feedId.feedUrl)
        let expectedArticles = [
            Article(
                title: "Item 1",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishDate1,
                authors: [],
                feedId: feedId
            ),
            Article(
                title: "Item 2",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/2")!,
                publishedAt: publishDate2,
                authors: [],
                feedId: feedId
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenRequiredFieldsMissingOnSomeItems_faultyItemsIgnored() {
        let publishDate1 = Date()
        let feedId = Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
        
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            items: [
                rssItem(
                    title: "Item 1",
                    description: nil,
                    articleUrl: "https://hello.mock/1",
                    publishedAt: publishDate1,
                    author: nil
                ),
                rssItem(
                    title: nil,
                    description: nil,
                    articleUrl: "https://hello.mock/2",
                    publishedAt: nil,
                    author: nil
                ),
            ]
        )
        
        let articles = sut.articles(from: rss, feedUrl: feedId.feedUrl)
        let expectedArticles = [
            Article(
                title: "Item 1",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishDate1,
                authors: [],
                feedId: feedId
            )
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
    
    func test_articlesFrom_whenTitleMissing_usesUntitled() {
        let publishDate1 = Date()
        let feedId = Feed.ID(feedUrl: URL(string: "https://hello.mock")!)
        
        let rss = rssFeed(
            title: "A channel",
            description: "A really awesome channel",
            link: "https://hello.mock",
            items: [
                rssItem(
                    title: nil,
                    description: nil,
                    articleUrl: "https://hello.mock/1",
                    publishedAt: publishDate1,
                    author: nil
                ),
            ]
        )
        
        let articles = sut.articles(from: rss, feedUrl: feedId.feedUrl)
        let expectedArticles = [
            Article(
                title: "Untitled",
                summary: nil,
                articleUrl: URL(string: "https://hello.mock/1")!,
                publishedAt: publishDate1,
                authors: [],
                feedId: feedId
            ),
        ]
        
        XCTAssertEqual(articles, expectedArticles)
    }
}

extension FeedProviderRSSParsingTests {
    func rssFeed(
        title: String,
        description: String,
        link: String,
        iconUrl: String? = nil,
        items: [Item] = []
    ) -> RSS {
        RSS(
            version: .v2_0,
            channel: Channel(
                title: title,
                description: description,
                link: URL(string: link)!,
                categories: [],
                copyright: nil,
                generator: nil,
                image: iconUrl.map({
                    RSSImage(
                        link: URL(string: link)!,
                        title: "Icon",
                        url: URL(string: $0)!,
                        description: nil,
                        width: nil,
                        height: nil
                    )
                }),
                language: nil,
                lastBuildDate: nil,
                managingEditor: nil,
                pubDate: nil,
                skipDays: [],
                skipHours: SkipHours(hours: []),
                ttl: nil,
                webMaster: nil,
                items: items
            )
        )
    }
    
    func rssItem(
        title: String?,
        description: String?,
        articleUrl: String?,
        publishedAt: Date?,
        author: String?
    ) -> Item {
        Item(
            title: title,
            description: description,
            guid: articleUrl.map({ GUID(contents: $0, isPermaLink: false) }),
            link: articleUrl.flatMap(URL.init(string:)),
            author: author,
            categories: [],
            commentsUrl: nil,
            pubDate: publishedAt
        )
    }
}
