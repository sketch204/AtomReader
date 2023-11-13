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
