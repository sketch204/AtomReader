//
//  ReadingHistoryView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-21.
//

import SwiftUI

struct ReadingHistoryView: View {
    @Environment(ReadingHistoryStore.self) private var readingHistory
    
    @State private var isClearingHistory: Bool = false
    
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
        .overlay {
            if readingHistory.readArticles.isEmpty {
                emptyReadingHistoryView
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Clear") {
                    isClearingHistory = true
                }
            }
        }
        .confirmationDialog(
            "Are you sure you want to clear your reading history?",
            isPresented: $isClearingHistory
        ) {
            Button("Clear", role: .destructive) {
                readingHistory.clear()
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            #if os(iOS)
            Text("Are you sure you want to clear your reading history? This action cannot be undone.")
            #elseif os(macOS)
            Text("This action cannot be undone.")
            #endif
        }

        #if os(iOS)
        .listStyle(.plain)
        #endif
    }
    
    var emptyReadingHistoryView: some View {
        ContentUnavailableView {
            Text("No reading history")
        } description: {
            Text("Read some articles. They'll show up here when you do.")
        }
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
                
                Text("Read \(dateString)")
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
