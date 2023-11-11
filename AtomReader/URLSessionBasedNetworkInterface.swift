//
//  URLSessionBasedNetworkInterface.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct URLSessionBasedNetworkInterface: FeedProviderNetworkInterface {
    func data(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
