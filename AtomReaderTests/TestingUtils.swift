//
//  TestingUtils.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation
@testable import AtomReader

let mockFeed1Old = Feed(
    name: "Old Feed",
    description: "",
    iconUrl: nil,
    websiteUrl: mockFeed1.websiteUrl,
    atomFeedUrl: mockFeed1.atomFeedUrl
)
let mockFeed1 = Feed(
    name: "Hello Feed",
    description: "Feed for hello",
    iconUrl: nil,
    websiteUrl: URL(string: "https://hello.mock")!,
    atomFeedUrl: URL(string: "https://hello.mock")!
)
let mockFeed1Article1 = Article(
    title: "Hello Feed Article 1",
    excerpt: nil,
    articleUrl: URL(string: "https://hello.mock/1")!,
    publishedAt: Date(),
    authors: [],
    feedId: mockFeed1.id
)
let mockFeed1Article2 = Article(
    title: "Hello Feed Article 2",
    excerpt: nil,
    articleUrl: URL(string: "https://hello.mock/2")!,
    publishedAt: Date(),
    authors: [],
    feedId: mockFeed1.id
)
let mockFeed2 = Feed(
    name: "Goodbye Feed",
    description: "Feed for goodbye",
    iconUrl: nil,
    websiteUrl: URL(string: "https://goobye.mock")!,
    atomFeedUrl: URL(string: "https://goobye.mock")!
)
let mockFeed2Article1 = Article(
    title: "Goodbye Feed Article 1",
    excerpt: nil,
    articleUrl: URL(string: "https://goodbye.mock/1")!,
    publishedAt: Date(),
    authors: [],
    feedId: mockFeed2.id
)


struct MockDataProvider: StoreDataProvider {
    func feed(at url: URL) async throws -> Feed {
        switch url {
        case mockFeed1.atomFeedUrl:
            mockFeed1
        case mockFeed2.atomFeedUrl:
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


extension Feed: CustomStringConvertible {
    public var description: String {
        "\(name) - \(atomFeedUrl)"
    }
}

extension Article: CustomStringConvertible {
    public var description: String {
        "\(title) - \(articleUrl)"
    }
}
