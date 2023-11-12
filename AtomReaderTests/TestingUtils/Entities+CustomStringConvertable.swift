//
//  Entities+CustomStringConvertable.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
@testable import AtomReader

extension Feed: CustomStringConvertible {
    public var description: String {
        "\(name) - \(feedUrl)"
    }
}

extension Article: CustomStringConvertible {
    public var description: String {
        "\(title) - \(articleUrl)"
    }
}
