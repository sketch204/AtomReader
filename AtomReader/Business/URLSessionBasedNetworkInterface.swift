//
//  URLSessionBasedNetworkInterface.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import Foundation

struct URLSessionBasedNetworkInterface {
    let session = URLSession.shared
}

extension URLSessionBasedNetworkInterface: FeedProviderNetworkInterface {
    func data(from url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
}

extension URLSessionBasedNetworkInterface: FeedPreviewerNetworkInterface {
    struct InvalidResponse: Error {}
    
    func responseContentType(for url: URL) async throws -> String {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let (_, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              let contentType = response.value(forHTTPHeaderField: "content-type")
        else {
            throw InvalidResponse()
        }
        
        return contentType
    }
}
