//
//  Feed.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct Feed {
    let name: String
    let description: String // subtitle
    
    let iconUrl: URL?
    
    let websiteUrl: URL
    let atomFeedUrl: URL
}

extension Feed: Identifiable {
    struct ID: Hashable {
        let atomFeedUrl: URL
        
        init(atomFeedUrl: URL) {
            self.atomFeedUrl = atomFeedUrl
        }
        
        init(feed: Feed) {
            self.init(atomFeedUrl: feed.atomFeedUrl)
        }
    }
    
    var id: ID {
        ID(feed: self)
    }
}
