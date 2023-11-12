//
//  ContentView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import AtomParser

struct ContentView: View {
    @Environment(Store.self) private var store
    
    @State private var filter: ArticleFilter = .none
    
    @State private var isAddingFeed: Bool = false
    
    var body: some View {
        NavigationSplitView {
            ArticleFilterView(filter: $filter)
                .toolbar {
                    ToolbarItem {
                        Button {
                            isAddingFeed = true
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
        .sheet(isPresented: $isAddingFeed) {
            AddFeedView()
        }
    }
}

#Preview {
    ContentView()
        .previewStore()
}
