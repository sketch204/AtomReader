//
//  MockDataProvider.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
@testable import AtomReader

struct MockDataProvider {
    func feed(at url: URL) async throws -> Feed {
        switch url {
        case mockFeed1.feedUrl:
            mockFeed1
        case mockFeed2.feedUrl:
            mockFeed2
        default:
            throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
    
    func articles(for feed: Feed) async throws -> [Article] {
        switch feed.id {
        case mockFeed1.id: mockFeed1Articles
        case mockFeed2.id: mockFeed2Articles
        case mockFeed3.id: []
        default: throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}

extension MockDataProvider: StoreDataProvider {}
extension MockDataProvider: FeedPreviewerDataProvider {}
