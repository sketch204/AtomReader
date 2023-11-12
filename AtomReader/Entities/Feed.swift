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
        let atomFeedUrl: URL
        
        init(atomFeedUrl: URL) {
            self.atomFeedUrl = atomFeedUrl
        }
        
        init(feed: Feed) {
            self.init(atomFeedUrl: feed.feedUrl)
        }
    }
    
    var id: ID {
        ID(feed: self)
    }
}
