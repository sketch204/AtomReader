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
    
    var body: some View {
        NavigationSplitView {
            ArticleFilterView(filter: $filter)
                .toolbar {
                    ToolbarItem {
                        Button {
                            appActions.perform(AddFeedAction())
                        } label: {
                            Label("Add Feed", systemImage: "plus")
                        }
                    }
                }
        } detail: {
            NavigationStack {
                ArticleListView(
                    viewModel: ArticleListViewModel(
                        store: store,
                        filter: filter
                    )
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .previewStore()
}
