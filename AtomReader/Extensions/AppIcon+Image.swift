//
//  AppIcon+Image.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

#if os(iOS)

import SwiftUI

extension AppIcon {
    @ViewBuilder
    var image: some View {
        if let image = UIImage(named: rawValue) {
            Image(uiImage: image)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image(systemName: "questionmark.square.dashed")
        }
    }
}

#endif
