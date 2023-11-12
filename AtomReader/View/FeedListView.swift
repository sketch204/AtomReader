//
//  FeedListView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct FeedListView: View {
    @Environment(Store.self) private var store
    
    @Binding var feedSelection: Feed.ID?
    
    var body: some View {
        List(store.feeds, selection: $feedSelection) { feed in
            FeedRowView(feed: feed)
        }
    }
}

#Preview {
    FeedListView(feedSelection: .constant(nil))
}
