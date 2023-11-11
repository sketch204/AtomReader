//
//  TestingUtils.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation
@testable import AtomReader

let mockFeedUrl1 = URL(string: "https://hello.mock")!
let mockFeedUrl2 = URL(string: "https://goobye.mock")!
let mockFeed1 = Feed(
    name: "Hello Feed",
    description: "Feed for hello",
    iconUrl: nil,
    websiteUrl: mockFeedUrl1,
    atomFeedUrl: mockFeedUrl1
)
let mockFeed2 = Feed(
    name: "Goodbye Feed",
    description: "Feed for goodbye",
    iconUrl: nil,
    websiteUrl: mockFeedUrl2,
    atomFeedUrl: mockFeedUrl2
)


struct MockDataProvider: StoreDataProvider {
    func feed(at url: URL) async throws -> Feed {
        switch url {
        case mockFeedUrl1:
            mockFeed1
        case mockFeedUrl2:
            mockFeed2
        default:
            throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
