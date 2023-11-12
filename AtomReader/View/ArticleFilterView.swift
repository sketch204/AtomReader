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
            Text("All")
                .tag(ArticleFilter.none)
            
            Section {
                ForEachFeed { feed in
                    Text(feed.name)
                        .tag(ArticleFilter.feed(feed.id))
                }
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
