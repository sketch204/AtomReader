//
//  FeedImage.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-12-04.
//

import SwiftUI

struct FeedImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(.tertiary)
                )
        } placeholder: {
            Image(systemName: "dot.radiowaves.up.forward")
                .resizable()
                .offset(x: 1)
                .padding(9)
                .background(
                    Circle()
                        .stroke(lineWidth: 2)
                )
                .foregroundStyle(.accent.gradient.opacity(0.8))
                
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: 32)
        .fixedSize()
    }
}

#Preview {
    VStack {
        FeedImage(url: URL(string: "https://www.donnywals.com/wp-content/uploads/cropped-site-icon-32x32.png"))
        FeedImage(url: nil)
    }
    .padding()
}
