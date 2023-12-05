//
//  Article.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct Article: Hashable {
    let title: String
    let summary: String?
    let articleUrl: URL
    let publishedAt: Date
    let authors: [String]
    
    let feedId: Feed.ID
}

extension Article: Identifiable {
    struct ID: Hashable {
        let articleUrl: URL
        let publishedAt: Date
        let feedId: Feed.ID
        
        init(articleUrl: URL, publishedAt: Date, feedId: Feed.ID) {
            self.articleUrl = articleUrl
            self.publishedAt = publishedAt
            self.feedId = feedId
        }
        
        init(article: Article) {
            self.init(
                articleUrl: article.articleUrl,
                publishedAt: article.publishedAt,
                feedId: article.feedId
            )
        }
    }
    
    var id: ID {
        ID(article: self)
    }
}
