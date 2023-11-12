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
            #endif
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
