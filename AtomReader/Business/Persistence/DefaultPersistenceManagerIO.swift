//
//  DefaultPersistenceManagerIO.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import Foundation

struct DefaultPersistenceManagerIO: PersistenceManagerIO {
    var persistenceUrl: URL {
        try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
    
    func readData(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
    
    func writeData(_ data: Data, to url: URL) throws {
        try data.write(to: url)
    }
}
