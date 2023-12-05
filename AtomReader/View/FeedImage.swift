//
//  FeedImage.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-12-04.
//

import SwiftUI

struct FeedImage: View {
    let url: URL?
    var size: CGFloat = 24
    
    private var shape: some Shape {
        #if os(iOS)
        RoundedRectangle(cornerRadius: size * (4/24))
        #elseif os(macOS)
        Circle()
        #endif
    }
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .clipShape(shape)
                .overlay(
                    shape.stroke(.tertiary)
                )
        } placeholder: {
            Image(systemName: "dot.radiowaves.up.forward")
                .resizable()
            #if os(iOS)
                .padding(size * (5/24))
            #elseif os(macOS)
                .offset(x: size * (1/32))
                .padding(size * (1/4))
            #endif
                .overlay(
                    shape
                        .stroke(lineWidth: size * (1/16))
                )
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
