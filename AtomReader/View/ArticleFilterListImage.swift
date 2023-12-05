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
        return 24
        #elseif os(macOS)
        return 18
        #endif
    }
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: imageSize * (4/24))
    }
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
        #if os(iOS)
            .padding(imageSize * (4/24))
            .overlay(
                shape
                    .stroke(lineWidth: imageSize * (1/16))
                    .aspectRatio(contentMode: .fit)
            )
        #endif
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
            ArticleFilterListImage(systemName: "square.3.stack.3d")
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
