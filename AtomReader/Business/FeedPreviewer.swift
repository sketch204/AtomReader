//
//  FeedPreviewer.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

import Foundation
import AtomURLResolver

protocol FeedPreviewerDataProvider {
    func feed(at url: URL) async throws -> Feed
}

protocol FeedPreviewerNetworkInterface {
    func data(from url: URL) async throws -> Data
    func responseContentType(for url: URL) async throws -> String
}

struct FeedPreviewer {
    let feedProvider: FeedPreviewerDataProvider
    let networkInterface: FeedPreviewerNetworkInterface
}

extension FeedPreviewer {
    struct InvalidResponse: Error {}
    
    func previewFeeds(at url: URL) async throws -> [Feed] {
        let responseContentType = try await networkInterface.responseContentType(for: url)
        
        if responseContentType.contains(/(rss|atom|xml)/) {
            let feed = try await feedProvider.feed(at: url)
            return [feed]
        }
        else if responseContentType.contains("html") {
            return try await parseHtmlForFeeds(url: url)
        }
        else {
            throw InvalidResponse()
        }
    }
    
    private func parseHtmlForFeeds(url: URL) async throws -> [Feed] {
        let data = try await networkInterface.data(from: url)
        
        let urls = try feedLinks(from: data, at: url)
        
        let feeds = try await feeds(at: urls)
        
        return feeds
    }
    
    private func feedLinks(from htmlData: Data, at url: URL) throws -> [URL] {
        let resolver = AtomURLResolver(data: htmlData, url: url)
        
        let links = try resolver.findLinks()
        
        return links.map(\.url)
    }
    
    private func feeds(at urls: [URL]) async throws -> [Feed] {
        try await withThrowingTaskGroup(of: Feed.self, returning: [Feed].self) { group in
            for url in urls {
                group.addTask {
                    try await feed(at: url)
                }
            }
            
            var output = [Feed]()
            
            for try await feed in group {
                output.append(feed)
            }
            
            return output
        }
    }
    
    private func feed(at url: URL) async throws -> Feed {
        try await feedProvider.feed(at: url)
    }
}
