//
//  ArticleListView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import WebView

struct ArticleListView: View {
    @Environment(\.openURL) private var openUrl
    @Environment(Store.self) private var store
    
    var feed: Feed.ID? = nil
    
    private var articles: [Article] {
        if let feed {
            store.articles(for: feed)
        } else {
            store.articles
        }
    }
    
    var body: some View {
        List(articles) { article in
//            Button {
//                openUrl(article.articleUrl)
//            } label: {
//                ArticleRowView(article: article)
//            }
            NavigationLink(value: article.articleUrl) {
                ArticleRowView(article: article)
            }
        }
        .buttonStyle(.plain)
        .navigationDestination(for: URL.self) { url in
            WebView(url: url)
        }
    }
}

#Preview {
    ArticleListView()
}
