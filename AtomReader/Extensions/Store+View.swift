//
//  Store+View.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

extension Store {
    func articles(for feedId: Feed.ID) -> [Article] {
        articles.filter({ $0.feedId == feedId })
    }
    
    func articles(for category: Category) -> [Article] {
        let categoryFeedIds = Set(feeds(for: category).map(\.id))
        return articles.filter({ categoryFeedIds.contains($0.feedId) })
    }
}
