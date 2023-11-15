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
        Text(feed.displayName)
    }
}

#Preview {
    FeedRowView(feed: .previewFeed1)
}
