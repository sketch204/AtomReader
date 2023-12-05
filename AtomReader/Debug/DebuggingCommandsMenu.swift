//
//  DebuggingCommandsMenu.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-30.
//

import SwiftUI

#if os(macOS) && DEBUG

struct DebuggingCommandsMenu: Commands {
    var body: some Commands {
        CommandMenu("Debug") {
            Button("Open Store location...") {
                let persistenceManagerIO = DefaultPersistenceManagerIO()
                NSWorkspace.shared.open(persistenceManagerIO.persistenceUrl)
            }
        }
    }
}

extension Scene {
    func debugCommands() -> some Scene {
        commands(content: { DebuggingCommandsMenu() })
    }
}

#endif
