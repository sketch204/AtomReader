//
//  ReadArticle.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import Foundation

struct ReadArticle: Hashable {
    let article: Article
    let readAt: Date
}

extension ReadArticle: Identifiable {
    var id: Article.ID {
        article.id
    }
}
