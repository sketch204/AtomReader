//
//  Feed+View.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import Foundation

extension Feed {
    var displayName: String {
        nameOverride ?? name
    }
}
