//
//  Feed+Preview.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

extension Feed {
    static var previewFeed1 = Self(
        name: "Super feed",
        description: "This feed is super serious.",
        iconUrl: nil,
        websiteUrl: URL(string: "https://super.serious/")!,
        feedUrl: URL(string: "https://super.serious/feed.xml")!
    )
    
    static var previewFeed2 = Self(
        name: "Chillax",
        description: "This feed is anything but serious. Only good vibes here.",
        iconUrl: nil,
        websiteUrl: URL(string: "https://super.chill/")!,
        feedUrl: URL(string: "https://super.chill/feed.rss")!
    )
    
    static var previewFeeds: [Self] = [previewFeed1, previewFeed2]
}
