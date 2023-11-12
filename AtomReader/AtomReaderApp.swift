//
//  AtomReaderApp.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

@main
struct AtomReaderApp: App {
    private let appActions = AppActions()
    
    private let store = Store(
        dataProvider: FeedProvider(
            networkInterface: URLSessionBasedNetworkInterface()
        ),
        persistenceManager: FileBasedPersistenceManager()
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handleAddFeedAction()
        }
        .environment(store)
        .environment(appActions)
    }
}
