//
//  RemoveFeedAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct RemoveFeedAction: AppAction {
    let feed: Feed
}

fileprivate struct RemoveFeedActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    @Environment(Store.self) private var store
    
    @State private var isShowingConfirmationDialog: Bool = false
    @State private var removeAction: RemoveFeedAction?
    
    private var confirmationDialogTitle: LocalizedStringKey {
        if let removeAction {
            "Are you sure you want to remove \(removeAction.feed.displayName)?"
        } else {
            "Are you sure you want to remove this feed?"
        }
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: RemoveFeedAction.self)) { action in
                removeAction = action
                isShowingConfirmationDialog = true
            }
            .confirmationDialog(
                confirmationDialogTitle,
                isPresented: $isShowingConfirmationDialog
            ) {
                Button("Remove", role: .destructive) {
                    performRemoval()
                }
                
                Button("Cancel", role: .cancel) {
                    isShowingConfirmationDialog = false
                    removeAction = nil
                }
            } message: {
                Text("This action cannot be undone.")
            }
    }
    
    private func performRemoval() {
        guard let removeAction else { return }
        store.removeFeed(removeAction.feed)
        self.removeAction = nil
    }
}

extension View {
    func handleRemoveFeedAction() -> some View {
        modifier(RemoveFeedActionHandler())
    }
}
