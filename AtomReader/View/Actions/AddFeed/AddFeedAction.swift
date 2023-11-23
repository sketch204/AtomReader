//
//  AddFeedAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI

struct AddFeedAction: AppAction {
    var url: URL?
}

extension AddFeedAction: Identifiable {
    var id: URL? { url }
}

fileprivate struct AddFeedActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    @Environment(Store.self) private var store
    
    @State private var addFeedAction: AddFeedAction?
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: AddFeedAction.self)) { action in
                addFeedAction = action
            }
            .handlesExternalEvents(preferring: ["feed"], allowing: ["feed"])
            .onOpenURL(perform: { url in
                let feedUrlString = String(url.absoluteString.trimmingPrefix("feed:"))
                guard let feedUrl = URL(string: feedUrlString) else { return }
                addFeedAction = AddFeedAction(url: feedUrl)
            })
            .sheet(item: $addFeedAction) { action in
                let networkInterface = URLSessionBasedNetworkInterface()
                
                let view = AddFeedView(
                    viewModel: AddFeedViewModel(
                        store: store,
                        feedPreviewer: FeedPreviewer(
                            feedProvider: FeedProvider(networkInterface: networkInterface),
                            networkInterface: networkInterface
                        ),
                        url: action.url
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
