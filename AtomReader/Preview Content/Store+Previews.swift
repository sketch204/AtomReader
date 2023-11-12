//
//  Store+Previews.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

extension Store {
    static func preview(
        dataProvider: StoreDataProvider = PreviewStoreDataProvider(),
        feeds: [Feed] = Feed.previewFeeds,
        articles: [Article] = Article.previewArticles
    ) -> Self {
        Self.init(dataProvider: dataProvider, feeds: feeds, articles: articles)
    }
}
