//
//  ReadArticleDTO.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import Foundation

struct ReadArticleDTO: Codable {
    let articleDto: ArticleDTO
    let readAt: Date
    
    init(from readArticle: ReadArticle) {
        self.articleDto = ArticleDTO(from: readArticle.article)
        self.readAt = readArticle.readAt
    }
    
    enum CodingKeys: String, CodingKey {
        case articleDto = "article"
        case readAt
    }
}

extension ReadArticle {
    init(from dto: ReadArticleDTO) {
        self.init(
            article: Article(from: dto.articleDto),
            readAt: dto.readAt
        )
    }
}
