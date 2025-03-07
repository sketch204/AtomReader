//
//  ArticleFilter.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

enum ArticleFilter: Equatable, Hashable {
    case none
    case feed(Feed.ID)
    case category(Category)
    case history
}

extension ArticleFilter: Identifiable {
    var id: Self { self }
}
