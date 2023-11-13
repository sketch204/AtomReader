//
//  ArticleRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct ArticleRowView: View {
    @AppStorage("articlePreviewMaxNumberOfLines")
    private var articlePreviewMaxNumberOfLines: Int = 5
    
    let article: Article
    let feed: Feed
    
    private var dateString: String {
        article.publishedAt
            .formatted(.relative(presentation: .named))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text(article.title)
                        .font(.title2)
                    
                    Spacer()
                    
                    Text(dateString)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
                
                Text(feed.name)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            
            if let excerpt = article.excerpt {
                Text(excerpt)
                    .lineLimit(articlePreviewMaxNumberOfLines)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        ArticleRowView(article: .previewFeed1Article1, feed: .previewFeed1)
        ArticleRowView(article: .previewFeed1Article2, feed: .previewFeed1)
        ArticleRowView(article: .previewFeed2Article1, feed: .previewFeed2)
        ArticleRowView(
                article: Article(
                title: "An article",
                excerpt: "A show excerpt of the article. This is a really long excerpt. It has to span multiple lines. The more the better. This way I can test how a long excerpt will look in a list of feeds. It's not long enough! Make it longer. It must be three lines at the least.",
                articleUrl: URL(string: "https://feed.xml/articles/1")!,
                publishedAt: Date(),
                authors: ["Cool Dude"],
                feedId: Feed.ID(atomFeedUrl: URL(string: "https://feed.xml")!)
            ),
            feed: .previewFeed2
        )
    }
}
