//
//  AtomReaderApp.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI

@main
struct AtomReaderApp: App {
    private static let persistenceManager = FileBasedPersistenceManager()
    private let readingHistory = ReadingHistoryStore(persistenceManager: Self.persistenceManager)
    private let store = Store(
        dataProvider: FeedProvider(
            networkInterface: URLSessionBasedNetworkInterface()
        ),
        persistenceManager: Self.persistenceManager
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .handleAddFeedAction()
                .handleRemoveFeedAction()
                .handleFeedRenameAction()
                .handleEditCategoryAction()
                .handleRemoveCategoryAction()
        }
        .environment(store)
        .environment(readingHistory)
        #if os(macOS) && DEBUG
        .debugCommands()
        #endif
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
