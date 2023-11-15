//
//  ArticleDTO.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

struct ArticleDTO: Codable {
    let title: String
    let excerpt: String?
    let articleUrl: URL
    let publishedAt: Date
    let authors: [String]
    let feedId: URL
    
    init(from article: Article) {
        self.title = article.title
        self.excerpt = article.summary
        self.articleUrl = article.articleUrl
        self.publishedAt = article.publishedAt
        self.authors = article.authors
        self.feedId = article.feedId.feedUrl
    }
}

extension Article {
    init(from dto: ArticleDTO) {
        self.init(
            title: dto.title,
            summary: dto.excerpt,
            articleUrl: dto.articleUrl,
            publishedAt: dto.publishedAt,
            authors: dto.authors,
            feedId: Feed.ID(feedUrl: dto.feedId)
        )
    }
}
