//
//  ArticleFilterListImage.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-12-04.
//

import SwiftUI

struct ArticleFilterListImage: View {
    let systemName: String
    
    var imageSize: CGFloat {
        #if os(iOS)
        return 32
        #elseif os(macOS)
        return 18
        #endif
    }
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imageSize)
            .fontWeight(.light)
            .fixedSize()
    }
}

#Preview {
    List {
        Label {
            Text("All")
        } icon: {
            ArticleFilterListImage(systemName: "list.bullet.circle")
        }
        
        FeedRowView(
            feed: Feed(
                name: "Name",
                description: nil,
                iconUrl: nil,
                websiteUrl: URL(string: "https://s")!,
                feedUrl: URL(string: "https://s")!
            )
        )
        FeedRowView(feed: .previewFeed1)
    }
}
