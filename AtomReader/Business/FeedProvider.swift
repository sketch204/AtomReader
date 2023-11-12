//
//  FeedProvider.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation
import AtomParser

protocol FeedProviderNetworkInterface {
    func data(from url: URL) async throws -> Data
}

final class FeedProvider {
    private var feeds = [Feed.ID: Feed]()
    private var articles = [Feed.ID: [Article]]()
    
    private let networkInterface: FeedProviderNetworkInterface
    
    init(networkInterface: FeedProviderNetworkInterface) {
        self.networkInterface = networkInterface
    }
}

extension FeedProvider: StoreDataProvider {
    struct UnrecognizedFeedFormat: Error {}
    
    func feed(at url: URL) async throws -> Feed {
        let data = try await networkInterface.data(from: url)
        let parser = try FeedParser(data: data)
        let parsedFeed = try parser.parse()
        
        let results: (feed: Feed, articles: [Article])
        
        if let parsedFeed = parsedFeed as? AtomParser.Feed {
            results = try self.data(from: parsedFeed, feedUrl: url)
        }
        else if let parsedFeed = parsedFeed as? AtomParser.RSS {
            results = try self.data(from: parsedFeed, feedUrl: url)
        }
        else {
            throw UnrecognizedFeedFormat()
        }
        
        self.feeds[results.feed.id] = results.feed
        self.articles[results.feed.id] = results.articles
        
        return results.feed
    }
    
    func articles(for feed: Feed) async throws -> [Article] {
        if let articles = self.articles[feed.id] {
            return articles
        }
        
        let _ = try await self.feed(at: feed.atomFeedUrl)
        return self.articles[feed.id] ?? []
    }
}

extension FeedProvider {
    func data(from rss: AtomParser.RSS, feedUrl: URL) throws -> (feed: Feed, articles: [Article]) {
        let channel = rss.channel
        
        let feed = Feed(
            name: channel.title,
            description: channel.description,
            iconUrl: channel.image?.url,
            websiteUrl: channel.link,
            atomFeedUrl: feedUrl
        )
        
        let articles = channel.items.compactMap { item -> Article? in
            #warning("TODO: Optional fields")
            guard let link = item.link,
                  let publishedAt = item.pubDate
            else { return nil }
            
            return Article(
                title: item.title ?? "Untitled",
                excerpt: item.description,
                articleUrl: link,
                publishedAt: publishedAt,
                authors: [item.author].compactMap({ $0 }),
                feedId: feed.id
            )
        }
        
        return (feed, articles)
    }
}


extension FeedProvider {
    struct RequiredLinksNotFound: Error {}
    
    func data(from parsedFeed: AtomParser.Feed, feedUrl: URL) throws -> (feed: Feed, articles: [Article]) {
        guard let websiteLink = parsedFeed.links.first(where: { $0.relationship == .alternate })
        else {
            throw RequiredLinksNotFound()
        }
        
        let feed = Feed(
            name: parsedFeed.title.content,
            description: parsedFeed.subtitle?.content,
            // FIXME: iconUrl
            iconUrl: nil,//parsedFeed.icon?.path,
            websiteUrl: websiteLink.url,
            atomFeedUrl: feedUrl
        )
        
        let articles = parsedFeed.entries
            .map { entry in
                Article(
                    title: entry.title.content,
                    excerpt: entry.summary?.content,
                    articleUrl: entry.uri,
                    publishedAt: entry.published ?? entry.updated,
                    authors: entry.authors.map(\.name),
                    feedId: feed.id
                )
            }
        
        return (feed, articles)
    }
}
