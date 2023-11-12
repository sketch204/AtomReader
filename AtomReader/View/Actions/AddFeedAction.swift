//
//  AddFeedAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct AddFeedAction: AppAction {}

fileprivate struct AddFeedActionHandler: ViewModifier {
    @Environment(AppActions.self) private var appActions
    
    @State private var isAddingFeed = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: AddFeedAction.self)) { _ in
                isAddingFeed = true
            }
            .sheet(isPresented: $isAddingFeed) {
                AddFeedView()
            }
    }
}

extension View {
    func handleAddFeedAction() -> some View {
        modifier(AddFeedActionHandler())
    }
}
