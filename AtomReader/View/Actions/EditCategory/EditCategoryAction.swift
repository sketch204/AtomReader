//
//  EditCategoryAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2025-02-22.
//

import SwiftUI

struct AddCategoryAction: AppAction {}
struct EditCategoryAction: AppAction {
    let category: Category
}

fileprivate struct EditCategoryActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    @Environment(Store.self) private var store
    
    @State private var action: Action?
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: AddCategoryAction.self)) { _ in
                self.action = .add
            }
            .onReceive(appActions.events(for: EditCategoryAction.self)) { action in
                self.action = .edit(action.category)
            }
            .sheet(item: $action) { action in
                let view = EditCategoryView(category: action.category)
                
                #if os(macOS)
                view
                #elseif os(iOS)
                NavigationStack {
                    view
                }
                #endif
            }
    }
}

extension EditCategoryActionHandler {
    enum Action: Hashable, Identifiable {
        case add
        case edit(Category)
        
        var id: Self { self }
        
        var category: Category? {
            switch self {
            case .add: nil
            case .edit(let category): category
            }
        }
    }
}

extension View {
    func handleEditCategoryAction() -> some View {
        modifier(EditCategoryActionHandler())
    }
}
