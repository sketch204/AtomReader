//
//  RenameFeedAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import SwiftUI

struct RenameFeedAction: AppAction {
    let feed: Feed
}

fileprivate struct RenameFeedActionHandler: ViewModifier {
    @Environment(\.appActions) private var appActions
    
    @State private var renamedFeed: Feed?
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: RenameFeedAction.self)) { action in
                renamedFeed = action.feed
            }
            .sheet(item: $renamedFeed) { feed in
                RenameFeedView(feed: feed)
            }
    }
}

extension View {
    func handleFeedRenameAction() -> some View {
        modifier(RenameFeedActionHandler())
    }
}
