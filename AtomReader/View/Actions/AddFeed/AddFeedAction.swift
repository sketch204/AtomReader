//
//  AddFeedAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct AddFeedAction: AppAction {}

fileprivate struct AddFeedActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    @Environment(Store.self) private var store
    
    @State private var isAddingFeed = false
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: AddFeedAction.self)) { _ in
                isAddingFeed = true
            }
            .sheet(isPresented: $isAddingFeed) {
                let networkInterface = URLSessionBasedNetworkInterface()
                
                let view = AddFeedView(
                    viewModel: AddFeedViewModel(
                        store: store,
                        feedPreviewer: FeedPreviewer(
                            feedProvider: FeedProvider(networkInterface: networkInterface),
                            networkInterface: networkInterface
                        )
                    )
                )
                
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

extension View {
    func handleAddFeedAction() -> some View {
        modifier(AddFeedActionHandler())
    }
}
