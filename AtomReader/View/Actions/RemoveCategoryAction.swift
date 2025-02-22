//
//  RemoveCategoryAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2025-02-22.
//

import SwiftUI

struct RemoveCategoryAction: AppAction {
    let category: Category
}

fileprivate struct RemoveCategoryActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    @Environment(Store.self) private var store
    
    @State private var isShowingConfirmationDialog: Bool = false
    @State private var removeAction: RemoveCategoryAction?
    
    private var confirmationDialogTitle: LocalizedStringKey {
        if let removeAction {
            "Are you sure you want to remove \(removeAction.category.rawValue)?"
        } else {
            "Are you sure you want to remove this category?"
        }
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: RemoveCategoryAction.self)) { action in
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
                Text("This action cannot be undone")
            }

    }
    
    private func performRemoval() {
        guard let removeAction else { return }
        store.removeCategory(removeAction.category)
        self.removeAction = nil
        isShowingConfirmationDialog = false
    }
}

extension View {
    func handleRemoveCategoryAction() -> some View {
        modifier(RemoveCategoryActionHandler())
    }
}
