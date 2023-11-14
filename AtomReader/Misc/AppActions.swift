//
//  AppActions.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
import Combine
import SwiftUI

protocol AppAction {}

struct AppActions {
    private let subject = PassthroughSubject<AppAction, Never>()
    
    fileprivate init() {}
    
    func events<T>(for actionType: T.Type) -> AnyPublisher<T, Never> where T: AppAction {
        subject
            .compactMap({ $0 as? T })
            .eraseToAnyPublisher()
    }
    
    func perform(_ action: some AppAction) {
        subject.send(action)
    }
}

extension AppActions {
    fileprivate struct EnvironmentKey: SwiftUI.EnvironmentKey {
        static let defaultValue = AppActions()
    }
}

extension EnvironmentValues {
    var appActions: AppActions {
        self[AppActions.EnvironmentKey.self]
    }
}
