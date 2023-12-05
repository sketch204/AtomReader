//
//  FeedRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import SwiftUI

struct FeedRowView: View {
    let feed: Feed
    
    private var imageSize: CGFloat {
        #if os(iOS)
        return 32
        #elseif os(macOS)
        return 16
        #endif
    }
    
    var body: some View {
        Label {
            Text(feed.displayName)
        } icon: {
            FeedImage(url: feed.iconUrl, size: imageSize)
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
