//
//  ArticleFilterView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct ArticleFilterView: View {
    @Binding var filter: ArticleFilter?
    
    var body: some View {
        List(selection: $filter) {
            Section {
                Label {
                    Text("All")
                } icon: {
                    ArticleFilterListImage(systemName: "list.bullet.circle")
                }
                .tag(ArticleFilter.none)
            }
            
            Section {
                ForEachFeed { feed in
                    FeedRowView(feed: feed)
                        .tag(ArticleFilter.feed(feed.id))
                }
            }
            
            Section {
                Label {
                    Text("Reading History")
                } icon: {
                    ArticleFilterListImage(systemName: "clock")
                }
                .tag(ArticleFilter.history)
            }
        }
    }
}

#Preview {
    struct TestView: View {
        @State private var filter: ArticleFilter? = ArticleFilter.none
        
        var body: some View {
            ArticleFilterView(filter: $filter)
        }
    }
    
    return TestView()
        .previewStore()
}
