//
//  ArticleRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.title)
            
            if let excerpt = article.excerpt {
                Text(excerpt)
                    .font(.subheadline)
            }
            
            Text(article.publishedAt.formatted())
        }
    }
}

#Preview {
    ArticleRowView(
        article: Article(
            title: "An article",
            excerpt: "A show excerpt of the article",
            articleUrl: URL(string: "https://feed.xml/articles/1")!,
            publishedAt: Date(),
            authors: ["Cool Dude"],
            feedId: Feed.ID(atomFeedUrl: URL(string: "https://feed.xml")!)
        )
    )
}
