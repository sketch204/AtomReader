//
//  FeedRowView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

struct FeedRowView: View {
    let feed: Feed
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(feed.name)
                    .font(.title)
                
                Spacer()
                
                Text(feed.websiteUrl.absoluteString)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            if let description = feed.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    FeedRowView(
        feed: Feed(
            name: "A feed",
            description: "A very awesome feed!",
            iconUrl: nil,
            websiteUrl: URL(string: "https://feed.xml")!,
            feedUrl: URL(string: "https://feed.xml/feed")!
        )
    )
}
