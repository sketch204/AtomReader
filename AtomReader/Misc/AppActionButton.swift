//
//  File.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct AppActionButton<Action, Content>: View where Action: AppAction, Content: View {
    @Environment(AppActions.self) private var appActions
    
    let action: Action
    let label: () -> Content

    init(_ action: Action, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: { appActions.perform(action) }, label: label)
    }
}

extension AppActionButton where Content == Text {
    init(_ titleKey: LocalizedStringKey, action: Action) {
        self.init(action) {
            Text(titleKey)
        }
    }
    
    init<S>(_ title: S, action: Action) where S: StringProtocol {
        self.init(action) {
            Text(title)
        }
    }
}
