//
//  ContentView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import AtomParser

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(Store.self) private var store
    
    @State private var filter: ArticleFilter? = ArticleFilter.none
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
                .navigationTitle("Feeds")
        } detail: {
            NavigationStack(path: $navigationPath) {
                ArticleListView(
                    viewModel: ArticleListViewModel(
                        store: store,
                        filter: filter ?? .none
                    )
                )
                .navigationTitle("Articles")
            }
            .handleOpenArticleAction(navigationPath: $navigationPath)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                Task {
                    do {
                        try await store.refresh()
                    } catch {
                        Logger.app.critical("Failed to refresh store -- \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .previewStore()
}
