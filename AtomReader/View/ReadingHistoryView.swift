//
//  ReadingHistoryView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-21.
//

import SwiftUI

struct ReadingHistoryView: View {
    @Environment(ReadingHistoryStore.self) private var readingHistory
    
    var sortedEntries: [ReadArticle] {
        readingHistory.readArticles.sorted(using: KeyPathComparator(\.readAt, order: .reverse))
    }
    
    var body: some View {
        List {
            ForEach(sortedEntries) { entry in
                let action = OpenArticleAction(article: entry.article, shouldSkipHistoryTracking: true)
                
                AppActionButton(action) {
                    Row(entry: entry)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .onDelete { offsets in
                let articles = offsets
                    .map({ sortedEntries[$0] })
                    .map(\.article)
                readingHistory.mark(articles: articles, read: false)
            }
        }
        .navigationTitle("History")
        #if os(iOS)
        .listStyle(.plain)
        #endif
    }
}

extension ReadingHistoryView {
    struct Row: View {
        let entry: ReadArticle
        
        private var dateString: String {
            entry.readAt
                .formatted(.relative(presentation: .named))
        }
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(entry.article.title)
                    .font(.title2)
                
                Text(dateString)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    ReadingHistoryView()
}
