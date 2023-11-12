//
//  View+PreviewStore.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

extension View {
    func previewStore(_ store: Store) -> some View {
        environment(store)
    }
    
    func previewStore(
        dataProvider: StoreDataProvider = PreviewStoreDataProvider(),
        feeds: [Feed] = Feed.previewFeeds,
        articles: [Article] = Article.previewArticles
    ) -> some View {
        previewStore(
            .preview(
                dataProvider: dataProvider,
                feeds: feeds,
                articles: articles
            )
        )
    }
}
