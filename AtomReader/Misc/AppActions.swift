//
//  AppActions.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
import Combine

protocol AppAction {}

@Observable
final class AppActions {
    private let subject = PassthroughSubject<AppAction, Never>()
    
    func events<T>(for actionType: T.Type) -> AnyPublisher<T, Never> where T: AppAction {
        subject
            .compactMap({ $0 as? T })
            .eraseToAnyPublisher()
    }
    
    func perform(_ action: some AppAction) {
        subject.send(action)
    }
}
