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
    let nameOverride: String?
    
    init(from feed: Feed) {
        self.name = feed.name
        self.description = feed.description
        self.iconUrl = feed.iconUrl
        self.websiteUrl = feed.websiteUrl
        self.feedUrl = feed.feedUrl
        self.nameOverride = feed.nameOverride
    }
}

extension Feed {
    init(from dto: FeedDTO) {
        self.init(
            name: dto.name,
            description: dto.description,
            iconUrl: dto.iconUrl,
            websiteUrl: dto.websiteUrl,
            feedUrl: dto.feedUrl,
            nameOverride: dto.nameOverride
        )
    }
}
