//
//  MockDataProvider.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
@testable import AtomReader

struct MockDataProvider: StoreDataProvider {
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
        case mockFeed1.id: [mockFeed1Article1, mockFeed1Article2]
        case mockFeed2.id: [mockFeed2Article1]
        default: throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
