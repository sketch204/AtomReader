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
        }
        .buttonStyle(.plain)
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
