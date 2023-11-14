//
//  Feed+Unknown.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-13.
//

import Foundation

extension Feed {
    static let unknown = Self(
        name: "Unknown",
        description: nil,
        iconUrl: nil,
        websiteUrl: URL(string: "unknown")!,
        feedUrl: URL(string: "unknown")!
    )
}
