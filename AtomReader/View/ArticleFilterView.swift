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
                Text("All")
                    .tag(ArticleFilter.none)
            }
            
            Section {
                ForEachCategory { category in
                    Text(category.rawValue)
                        .tag(ArticleFilter.category(category))
                }
            }
            
            Section {
                ForEachFeed { feed in
                    FeedRowView(feed: feed)
                        .tag(ArticleFilter.feed(feed.id))
                }
            }
            
            Section {
                Text("Reading History")
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
