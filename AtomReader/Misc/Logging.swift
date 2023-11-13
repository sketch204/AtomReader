//
//  Logging.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
import os

typealias Logger = os.Logger

extension Logger {
    init(category: String) {
        self.init(subsystem: Bundle.main.identifier, category: category)
    }
}

extension Logger {
    static let app = Self(category: "📱 App")
    static let persistence = Self(category: "💾 Persistence")
    static let network = Self(category: "🛜 Network")
}
