//
//  FeedRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import SwiftUI

struct FeedRowView: View {
    let feed: Feed
    
    var body: some View {
        HStack {
            FeedImage(url: feed.iconUrl)

            Text(feed.displayName)
        }
    }
}

#Preview {
    List {
        FeedRowView(feed: .previewFeed1)
        FeedRowView(feed: .previewFeed2)
        FeedRowView(
            feed: Feed(
                name: "Some feed",
                description: "Some feed description",
                iconUrl: nil,
                websiteUrl: URL(string: "https://hello.mock")!,
                feedUrl: URL(string: "https://hello.mock.feed")!
            )
        )
    }
}
