//
//  PreviewNetworkInterface.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-19.
//

import Foundation

struct PreviewNetworkInterface {
    func data(from url: URL) async throws -> Data {
        switch url {
        case Feed.previewFeed1.feedUrl: Feed.previewFeed1Data
        case Feed.previewFeed2.feedUrl: Feed.previewFeed2Data
        default: throw UnsupportedPreviewData()
        }
    }
}

extension PreviewNetworkInterface: FeedProviderNetworkInterface {}
extension FeedProviderNetworkInterface where Self == PreviewNetworkInterface {
    static var preview: Self { Self() }
}

extension PreviewNetworkInterface: FeedPreviewerNetworkInterface {
    func responseContentType(for url: URL) async throws -> String {
        switch url {
        case Feed.previewFeed1.feedUrl, Feed.previewFeed2.feedUrl:
            "application/xml+rss"
        case Feed.previewFeed1.websiteUrl, Feed.previewFeed1.websiteUrl:
            "text/html"
        default:
            throw UnsupportedPreviewData()
        }
    }
}
extension FeedPreviewerNetworkInterface where Self == PreviewNetworkInterface {
    static var preview: Self { Self() }
}
