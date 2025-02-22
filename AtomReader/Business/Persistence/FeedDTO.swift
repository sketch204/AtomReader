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
    let categories: Set<Category>
    
    init(from feed: Feed) {
        self.name = feed.name
        self.description = feed.description
        self.iconUrl = feed.iconUrl
        self.websiteUrl = feed.websiteUrl
        self.feedUrl = feed.feedUrl
        self.nameOverride = feed.nameOverride
        self.categories = feed.categories
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.iconUrl = try container.decodeIfPresent(URL.self, forKey: .iconUrl)
        self.websiteUrl = try container.decode(URL.self, forKey: .websiteUrl)
        self.feedUrl = try container.decode(URL.self, forKey: .feedUrl)
        self.nameOverride = try container.decodeIfPresent(String.self, forKey: .nameOverride)
        self.categories = try container.decodeIfPresent(Set<Category>.self, forKey: .categories) ?? []
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
            nameOverride: dto.nameOverride,
            categories: dto.categories
        )
    }
}
