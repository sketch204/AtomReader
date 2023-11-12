//
//  ContentView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import AtomParser

struct ContentView: View {
    @State private var feedSelection: Feed.ID?
    
    @State private var isAddingFeed: Bool = false
    
    var body: some View {
        NavigationSplitView {
            FeedListView(feedSelection: $feedSelection)
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
            ArticleListView(feed: feedSelection)
        }
        .sheet(isPresented: $isAddingFeed) {
            AddFeedView()
        }
    }
}

#Preview {
    ContentView()
}
