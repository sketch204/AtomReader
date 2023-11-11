//
//  TestingUtils.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation
@testable import AtomReader

private let formatter = ISO8601DateFormatter()

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
    publishedAt: formatter.date(from: "2023-09-07T00:00:00+00:00")!,
    authors: ["Inal Gotov"],
    feedId: mockFeed1.id
)
let mockFeed1Article2 = Article(
    title: "Hello Feed Article 2",
    excerpt: nil,
    articleUrl: URL(string: "https://hello.mock/2")!,
    publishedAt: formatter.date(from: "2023-09-07T00:00:00+00:00")!,
    authors: ["Inal Gotov"],
    feedId: mockFeed1.id
)
let mockFeed1DataString = """
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" >
    <link href="https://hello.mock" rel="self" type="application/atom+xml" />
    <link href="https://hello.mock" rel="alternate" type="text/html" />
    <updated>2023-10-17T01:24:18+00:00</updated>
    <id>https://hello.mock</id>
    <title type="html">Hello Feed</title>
    <subtitle>Feed for hello</subtitle>
    <entry>
        <title type="html">Hello Feed Article 1</title>
        <published>2023-09-07T00:00:00+00:00</published>
        <updated>2023-09-07T00:00:00+00:00</updated>
        <id>https://hello.mock/1</id>
        <author>
            <name>Inal Gotov</name>
        </author>
    </entry>
    <entry>
        <title type="html">Hello Feed Article 2</title>
        <published>2023-09-07T00:00:00+00:00</published>
        <updated>2023-09-07T00:00:00+00:00</updated>
        <id>https://hello.mock/2</id>
        <author>
            <name>Inal Gotov</name>
        </author>
    </entry>
</feed>
"""
let mockFeed1Data = mockFeed1DataString.data(using: .utf8)!


let mockFeed2 = Feed(
    name: "Goodbye Feed",
    description: "Feed for goodbye",
    iconUrl: nil,
    websiteUrl: URL(string: "https://goodbye.mock")!,
    atomFeedUrl: URL(string: "https://goodbye.mock")!
)
let mockFeed2Article1 = Article(
    title: "Goodbye Feed Article 1",
    excerpt: nil,
    articleUrl: URL(string: "https://goodbye.mock/1")!,
    publishedAt: formatter.date(from: "2023-09-07T00:00:00+00:00")!,
    authors: [],
    feedId: mockFeed2.id
)

let mockFeed2DataString = """
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" >
    <link href="https://goodbye.mock" rel="self" type="application/atom+xml" />
    <link href="https://goodbye.mock" rel="alternate" type="text/html" />
    <updated>2023-10-17T01:24:18+00:00</updated>
    <id>https://goodbye.mock</id>
    <title type="html">Goodbye Feed</title>
    <subtitle>Feed for goodbye</subtitle>
    <entry>
        <title type="html">Goodbye Feed Article 1</title>
        <published>2023-09-07T00:00:00+00:00</published>
        <updated>2023-09-07T00:00:00+00:00</updated>
        <id>https://goodbye.mock/1</id>
    </entry>
</feed>
"""
let mockFeed2Data = mockFeed2DataString.data(using: .utf8)!


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
