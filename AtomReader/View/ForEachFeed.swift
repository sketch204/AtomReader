//
//  ForEachFeed.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct ForEachFeed<Content>: View where Content: View {
    @Environment(Store.self) private var store
    
    @ViewBuilder var content: (Feed) -> Content
    
    var body: some View {
        ForEach(store.feeds) { feed in
            content(feed)
                .contextMenu {
                    AppActionButton(RemoveFeedAction(feed: feed)) {
                        Label("Remove", systemImage: "trash")
                    }
                }
        }
        .onMove { sourceOffsets, targetOffset in
            store.moveFeeds(at: sourceOffsets, to: targetOffset)
        }
    }
}

#Preview {
    ForEachFeed { feed in
        Text(feed.name)
    }
}
