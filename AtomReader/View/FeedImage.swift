//
//  FeedImage.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-12-04.
//

import SwiftUI

struct FeedImage: View {
    let url: URL?
    var size: CGFloat = 32
    
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
                .offset(x: size * (1/32))
                .padding(size * (9/32))
                .background(
                    Circle()
                        .stroke(lineWidth: size * (2/32))
                )
//                .foregroundStyle(.accent.gradient.opacity(0.8))
                
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: size)
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
