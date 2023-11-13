//
//  Bundle.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

extension Bundle {
    private func infoDictionaryValue(for key: String, defaultValue: String = "Unknown") -> String {
        infoDictionary?[key] as? String ?? defaultValue
    }
    
    var version: String {
        infoDictionaryValue(for: "CFBundleShortVersionString")
    }
    
    var buildNumber: String {
        infoDictionaryValue(for: "CFBundleVersion")
    }
    
    var name: String {
        infoDictionaryValue(for: "CFBundleDisplayName")
    }
    
    var identifier: String {
        infoDictionaryValue(for: "CFBundleIdentifier")
    }
}
