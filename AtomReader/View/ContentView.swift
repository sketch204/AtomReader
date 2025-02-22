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
    
    @State private var isViewingSettings = false
    
    var body: some View {
        NavigationSplitView {
            ArticleFilterView(filter: $filter)
                .toolbar {
                    ToolbarItem {
                        AppActionButton(AddFeedAction()) {
                            Label("Add Feed", systemImage: "plus")
                        }
                    }
                    
                    ToolbarItem {
                        AppActionButton(AddCategoryAction()) {
                            Label("Add Category", systemImage: "tag")
                        }
                    }
                    
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isViewingSettings = true
                        } label: {
                            Label("Settings", systemImage: "gear")
                        }
                    }
                    #endif
                }
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
                .navigationTitle("Feeds")
        } detail: {
            NavigationStack(path: $navigationPath) {
                if filter == .history {
                    ReadingHistoryView()
                } else {
                    ArticleListView(
                        viewModel: ArticleListViewModel(
                            store: store,
                            filter: filter ?? .none
                        )
                    )
                }
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
        #if os(iOS)
        .sheet(isPresented: $isViewingSettings) {
            NavigationStack {
                SettingsView()
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") { isViewingSettings = false }
                        }
                    }
            }
        }
        #endif
    }
}

#Preview {
    ContentView()
        .previewStore()
}
