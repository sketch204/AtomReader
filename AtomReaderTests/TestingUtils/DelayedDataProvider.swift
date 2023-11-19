//
//  DelayedDataProvider.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation
@testable import AtomReader

struct DelayedDataProvider {
    private let provider = MockDataProvider()
    var delay: TimeInterval = 0.3
    
    func feed(at url: URL) async throws -> Feed {
        try await wait()
        return try await provider.feed(at: url)
    }
    
    func articles(for feed: Feed) async throws -> [Article] {
        try await wait()
        return try await provider.articles(for: feed)
    }
    
    private func wait() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
}

extension DelayedDataProvider: StoreDataProvider {}
extension DelayedDataProvider: FeedPreviewerDataProvider {}
