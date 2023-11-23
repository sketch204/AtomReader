//
//  PreviewStoreDataProvider.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

struct PreviewStoreDataProvider {
    func feed(at url: URL) async throws -> Feed {
        switch url {
        case Feed.previewFeed1.feedUrl: .previewFeed1
        case Feed.previewFeed2.feedUrl: .previewFeed2
        default: throw UnsupportedPreviewData()
        }
    }
    
    func articles(for feed: Feed) async throws -> [Article] {
        switch feed {
        case .previewFeed1: Article.previewFeed1Articles
        case .previewFeed2: Article.previewFeed2Articles
        default: throw UnsupportedPreviewData()
        }
    }
}


extension PreviewStoreDataProvider: StoreDataProvider {}
extension StoreDataProvider where Self == PreviewStoreDataProvider {
    static var preview: Self { Self() }
}

extension PreviewStoreDataProvider: FeedPreviewerDataProvider {}
extension FeedPreviewerDataProvider where Self == PreviewStoreDataProvider {
    static var preview: Self { Self() }
}
