//
//  Article+Preview.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

extension Article {
    static let previewFeed1Article1 = Self(
        title: "Something happened!",
        summary: "Something happened and we gotta act serious about it!",
        articleUrl: URL(string: "https://super.serious/1")!,
        publishedAt: Date(),
        authors: ["Super serious dude"],
        feedId: Feed.previewFeed1.id
    )
    
    static let previewFeed1Article2 = Self(
        title: "Something else happened!",
        summary: "Some other thing happened and we gotta act even more serious about it! You must care!",
        articleUrl: URL(string: "https://super.serious/2")!,
        publishedAt: Date(),
        authors: ["Super serious dude"],
        feedId: Feed.previewFeed1.id
    )
    
    static let previewFeed1Articles: [Self] = [.previewFeed1Article1, .previewFeed1Article2]
    
    static let previewFeed2Article1 = Self(
        title: "I think I thing happened?",
        summary: "Did something happen? Idk. We're super chill here.",
        articleUrl: URL(string: "https://super.chill/1")!,
        publishedAt: Date(),
        authors: ["Some dude"],
        feedId: Feed.previewFeed2.id
    )
    
    static let previewFeed2Articles: [Self] = [.previewFeed2Article1]
    
    static let previewArticles: [Self] = [.previewFeed1Article1, .previewFeed1Article2, .previewFeed2Article1]
}
