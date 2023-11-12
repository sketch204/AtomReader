//
//  ContentView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import AtomParser

struct ContentView: View {
    @Environment(AppActions.self) private var appActions
    @Environment(Store.self) private var store
    
    @State private var filter: ArticleFilter = .none
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            ArticleFilterView(filter: $filter)
                .toolbar {
                    ToolbarItem {
                        AppActionButton(AddFeedAction()) {
                            Label("Add Feed", systemImage: "plus")
                        }
                    }
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
        } detail: {
            NavigationStack(path: $navigationPath) {
                ArticleListView(
                    viewModel: ArticleListViewModel(
                        store: store,
                        filter: filter
                    )
                )
            }
            .handleOpenArticleAction(navigationPath: $navigationPath)
        }
    }
}

#Preview {
    ContentView()
        .previewStore()
        .previewAppActions()
}
