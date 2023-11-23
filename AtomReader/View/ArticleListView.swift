//
//  ArticleListView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import WebView

struct ArticleListView: View {
    @Environment(ReadingHistoryStore.self) private var readingHistory
    let viewModel: ArticleListViewModel
    
    var body: some View {
        List(viewModel.articles) { article in
            let isRead = readingHistory.isArticleRead(article)
            
            AppActionButton(OpenArticleAction(article: article)) {
                ArticleRowView(
                    article: article,
                    feed: viewModel.feed(for: article),
                    isRead: isRead
                )
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    readingHistory.mark(article: article, read: !isRead)
                } label: {
                    Label(
                        isRead ? "Mark Unread" : "Mark Read",
                        systemImage: isRead ? "eyeglasses.slash" : "eyeglasses"
                    )
                }
            }
        }
        .overlay {
            if viewModel.doesUserHaveNoFeeds {
                noFeedsView
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        #if os(macOS)
        .toolbar {
            Button {
                Task {
                    await viewModel.refresh()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            .disabled(viewModel.isLoading)
            .keyboardShortcut("r")
            .help("Refresh all channels (⌘ R)")
        }
        #endif
        .navigationTitle("Articles")
    }
    
    var noFeedsView: some View {
        ContentUnavailableView {
            Text("No Feeds")
        } description: {
            Text("Add a feed to start tracking its articles")
        } actions: {
            AppActionButton(AddFeedAction()) {
                Label("Add Feed", systemImage: "plus")
            }
        }
    }
}

#Preview {
    ArticleListView(
        viewModel: ArticleListViewModel(
            store: .preview()
        )
    )
    .previewStore()
}
