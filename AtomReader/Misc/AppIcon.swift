//
//  AppIcon.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

#if os(iOS)

import UIKit

struct AppIcon: RawRepresentable, Hashable {
    var rawValue: String
    
    static let light = Self(rawValue: "AppIconLight")
    static let dark = Self(rawValue: "AppIconDark")
    
    static var defaultIcon: Self { .light }
    static var all: [Self] {
        [.light, .dark]
    }
}

extension AppIcon: Identifiable {
    var id: RawValue { rawValue }
}

extension AppIcon {
    var displayName: String {
        switch self {
        case .light: "Light"
        case .dark: "Dark"
        default: "Unknown"
        }
    }
}

extension AppIcon {
    static var current: AppIcon {
        get {
            UIApplication.shared.alternateIconName.map(AppIcon.init(rawValue:)) ?? .light
        }
        set {
            setCurrent(newValue)
        }
    }
    
    static func setCurrent(_ icon: Self, completion: ((Error?) -> Void)? = nil) {
        var iconName: String? = icon.rawValue
        if icon == .defaultIcon {
            iconName = nil
        }
        UIApplication.shared.setAlternateIconName(iconName, completionHandler: completion)
    }
}

#endif
