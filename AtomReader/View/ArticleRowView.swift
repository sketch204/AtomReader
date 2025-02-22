//
//  ArticleRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct ArticleRowView: View {
    @AppStorage(SettingKeys.articlePreviewMaxNumberOfLines)
    private var articlePreviewMaxNumberOfLines: Int = 3
    
    let article: Article
    let feed: Feed
    var isRead: Bool = false
    
    private var dateString: String {
        article.publishedAt
            .formatted(.relative(presentation: .named))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.title2)
                
                HStack(alignment: .firstTextBaseline) {
                    Text(feed.displayName)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    Text(dateString)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
            }
            
            if let excerpt = article.summary, articlePreviewMaxNumberOfLines > 0 {
                Text(excerpt)
                    .lineLimit(articlePreviewMaxNumberOfLines)
            }
        }
        .opacity(isRead ? 0.7 : 1)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .animation(.default, value: isRead)
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
                summary: "A show excerpt of the article. This is a really long excerpt. It has to span multiple lines. The more the better. This way I can test how a long excerpt will look in a list of feeds. It's not long enough! Make it longer. It must be three lines at the least.",
                articleUrl: URL(string: "https://feed.xml/articles/1")!,
                publishedAt: Date(),
                authors: ["Cool Dude"],
                feedId: Feed.ID(feedUrl: URL(string: "https://feed.xml")!)
            ),
            feed: .previewFeed2
        )
    }
}
