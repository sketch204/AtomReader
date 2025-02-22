//
//  Category.swift
//  AtomReader
//
//  Created by Inal Gotov on 2025-02-22.
//

import Foundation

struct Category: RawRepresentable, Equatable, Hashable, Codable {
    var rawValue: String
    
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Category: Identifiable {
    var id: String { rawValue }
}
