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
    
    let viewModel: ArticleListViewModel
    
    var body: some View {
        List(viewModel.articles) { article in
            AppActionButton(OpenArticleAction(article: article)) {
                ArticleRowView(
                    article: article,
                    feed: viewModel.feed(for: article)
                )
            }
            .buttonStyle(.plain)
        }
        .overlay {
            if viewModel.doesUserHaveNoFeeds {
                noFeedsView
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .toolbar {
            #if os(macOS)
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
            #endif
        }
        .task {
            await viewModel.refresh()
        }
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
    .previewAppActions()
}
