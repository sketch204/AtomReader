//
//  Feed.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct Feed: Equatable {
    let name: String
    let description: String? // subtitle
    
    let iconUrl: URL?
    
    let websiteUrl: URL
    let feedUrl: URL
    
    var nameOverride: String?
    
    let categories: [Category]
    
    init(
        name: String,
        description: String?,
        iconUrl: URL?,
        websiteUrl: URL,
        feedUrl: URL,
        nameOverride: String? = nil,
        categories: [Category] = []
    ) {
        self.name = name
        self.description = description
        self.iconUrl = iconUrl
        self.websiteUrl = websiteUrl
        self.feedUrl = feedUrl
        self.nameOverride = nameOverride
        self.categories = categories
    }
}

extension Feed: Identifiable {
    struct ID: Hashable {
        let feedUrl: URL
        
        init(feedUrl: URL) {
            self.feedUrl = feedUrl
        }
        
        init(feed: Feed) {
            self.init(feedUrl: feed.feedUrl)
        }
    }
    
    var id: ID {
        ID(feed: self)
    }
}
