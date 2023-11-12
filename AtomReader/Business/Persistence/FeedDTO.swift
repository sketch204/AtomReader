//
//  FeedDTO.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

struct FeedDTO: Codable {
    let name: String
    let description: String?
    let iconUrl: URL?
    let websiteUrl: URL
    let feedUrl: URL
    
    init(from feed: Feed) {
        self.name = feed.name
        self.description = feed.description
        self.iconUrl = feed.iconUrl
        self.websiteUrl = feed.websiteUrl
        self.feedUrl = feed.feedUrl
    }
}

extension Feed {
    init(from dto: FeedDTO) {
        self.name = dto.name
        self.description = dto.description
        self.iconUrl = dto.iconUrl
        self.websiteUrl = dto.websiteUrl
        self.feedUrl = dto.feedUrl
    }
}
