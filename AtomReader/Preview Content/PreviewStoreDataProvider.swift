//
//  PreviewStoreDataProvider.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

struct PreviewStoreDataProvider: StoreDataProvider {
    struct UnsupportedPreviewData: Error {}
    
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
