//
//  MockFeedProviderNetworkInterface.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-13.
//

import Foundation
@testable import AtomReader

struct MockFeedProviderNetworkInterface: FeedProviderNetworkInterface {
    func data(from url: URL) async throws -> Data {
        switch url {
        case mockFeed1.feedUrl: mockFeed1Data
        case mockFeed2.feedUrl: mockFeed2Data
        default: throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
