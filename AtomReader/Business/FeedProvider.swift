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
    private var articles = [Feed.ID: [Article]]()
    
    private let networkInterface: FeedProviderNetworkInterface
    
    init(networkInterface: FeedProviderNetworkInterface) {
        self.networkInterface = networkInterface
    }
}

extension FeedProvider: StoreDataProvider {
    struct UnrecognizedFeedFormat: Error {}
    
    func feed(at url: URL) async throws -> Feed {
        Logger.network.trace("Fetching feed at \(url)")
        
        let data = try await networkInterface.data(from: url)
        let parser = try FeedParser(data: data)
        let parsedFeed = try parser.parse()
        
        let feed: Feed, articles: [Article]
        
        if let atomFeed = parsedFeed as? AtomParser.Feed {
            feed = try self.feed(from: atomFeed, feedUrl: url)
            articles = self.articles(from: atomFeed, feedUrl: url)
        }
        else if let rss = parsedFeed as? AtomParser.RSS {
            feed = self.feed(from: rss, feedUrl: url)
            articles = self.articles(from: rss, feedUrl: url)
        }
        else {
            throw UnrecognizedFeedFormat()
        }
        
        self.articles[feed.id] = articles
        
        return feed
    }
    
    func articles(for feed: Feed) async throws -> [Article] {
        Logger.network.trace("Fetching articles for \(feed.id.feedUrl)")
        
        if let articles = self.articles[feed.id] {
            return articles
        }
        
        let _ = try await self.feed(at: feed.feedUrl)
        return self.articles[feed.id] ?? []
    }
}

extension FeedProvider: FeedPreviewerDataProvider {}

extension FeedProvider {
    func feed(from rss: AtomParser.RSS, feedUrl: URL) -> Feed {
        Feed(
            name: rss.channel.title,
            description: rss.channel.description,
            iconUrl: rss.channel.image?.url,
            websiteUrl: rss.channel.link,
            feedUrl: feedUrl
        )
    }
    
    func articles(from rss: AtomParser.RSS, feedUrl: URL) -> [Article] {
        rss.channel.items.compactMap { item -> Article? in
            guard let link = item.link,
                  let publishedAt = item.pubDate
            else { return nil }
            
            return Article(
                title: item.title.map(removeHtml(from:)) ?? "Untitled",
                summary: item.description.map(removeHtml(from:)),
                articleUrl: link,
                publishedAt: publishedAt,
                authors: [item.author].compactMap({ $0 }),
                feedId: Feed.ID(feedUrl: feedUrl)
            )
        }
    }
}


extension FeedProvider {
    struct RequiredLinksNotFound: Error {}
    struct FailedToProcessURL: Error {
        let url: URL
    }
    
    func feed(from parsedFeed: AtomParser.Feed, feedUrl: URL) throws -> Feed {
        guard let websiteLink = parsedFeed.links.first(where: { $0.relationship == .alternate })
        else {
            throw RequiredLinksNotFound()
        }
        
        guard let baseUrl = baseUrl(from: feedUrl) else {
            throw FailedToProcessURL(url: feedUrl)
        }
        
        let websiteURL = switch websiteLink.href {
        case .absolute(let url): url
        case .relative(let path): baseUrl.appending(component: path)
        }
        
        return Feed(
            name: parsedFeed.title.content,
            description: parsedFeed.subtitle?.content,
            iconUrl: parsedFeed.icon
                .map(\.path)
                .map({ baseUrl.appending(path: $0) }),
            websiteUrl: websiteURL,
            feedUrl: feedUrl
        )
    }
    
    func articles(from parsedFeed: AtomParser.Feed, feedUrl: URL) -> [Article] {
        parsedFeed.entries
            .map { entry in
                Article(
                    title: removeHtml(from: entry.title.content),
                    summary: entry.summary.map({ removeHtml(from: $0.content) }),
                    articleUrl: entry.uri,
                    publishedAt: entry.published ?? entry.updated,
                    authors: entry.authors.map(\.name),
                    feedId: Feed.ID(feedUrl: feedUrl)
                )
            }
    }
    
    private func baseUrl(from url: URL) -> URL? {
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: false)
        comps?.path = ""
        return comps?.url
    }
}

extension FeedProvider {
    func removeHtml(from input: String) -> String {
        input.replacing(/\<.*?\>/, with: "")
    }
}
