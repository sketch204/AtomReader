//
//  File.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct AppActionButton<Action, Content>: View where Action: AppAction, Content: View {
    @Environment(AppActions.self) private var appActions
    
    let actionProvider: () -> Action
    let label: () -> Content

    init(_ actionProvider: @autoclosure @escaping () -> Action, @ViewBuilder label: @escaping () -> Content) {
        self.actionProvider = actionProvider
        self.label = label
    }
    
    var body: some View {
        Button(action: { appActions.perform(actionProvider()) }, label: label)
    }
}

extension AppActionButton where Content == Text {
    init(_ titleKey: LocalizedStringKey, actionProvider: @autoclosure @escaping () -> Action) {
        self.init(actionProvider()) {
            Text(titleKey)
        }
    }
    
    init<S>(_ title: S, actionProvider: @autoclosure @escaping () -> Action) where S: StringProtocol {
        self.init(actionProvider()) {
            Text(title)
        }
    }
}
