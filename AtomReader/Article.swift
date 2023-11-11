//
//  Article.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct Article: Equatable {
    let title: String
    let excerpt: String?
    let articleUrl: URL
    let publishedAt: Date
    let authors: [String]
}

extension Article: Identifiable {
    struct ID: Hashable {
        let title: String
        let articleUrl: URL
        let publishedAt: Date
        
        init(title: String, articleUrl: URL, publishedAt: Date) {
            self.title = title
            self.articleUrl = articleUrl
            self.publishedAt = publishedAt
        }
        
        init(article: Article) {
            self.init(title: article.title, articleUrl: article.articleUrl, publishedAt: article.publishedAt)
        }
    }
    
    var id: ID {
        ID(article: self)
    }
}
