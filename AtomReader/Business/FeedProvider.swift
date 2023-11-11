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
    func feed(at url: URL) async throws -> Feed {
        let data = try await networkInterface.data(from: url)
        let parsedFeed = try AtomParser.Feed(data: data)
        
        let (feed, articles) = try self.data(from: parsedFeed)
        
        self.feeds[feed.id] = feed
        self.articles[feed.id] = articles
        
        return feed
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
    struct RequiredLinksNotFound: Error {}
    
    func data(from parsedFeed: AtomParser.Feed) throws -> (feed: Feed, articles: [Article]) {
        guard let atomFeedLink = parsedFeed.links.first(where: { $0.relationship == .`self` }),
              let websiteLink = parsedFeed.links.first(where: { $0.relationship == .alternate })
        else {
            throw RequiredLinksNotFound()
        }
        let feed = Feed(
            name: parsedFeed.title.content,
            description: parsedFeed.subtitle?.content,
            // FIXME: iconUrl
            iconUrl: nil,//parsedFeed.icon?.path,
            websiteUrl: websiteLink.url,
            atomFeedUrl: atomFeedLink.url
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
