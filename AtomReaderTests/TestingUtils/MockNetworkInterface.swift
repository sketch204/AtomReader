//
//  MockNetworkInterface.swift
//  AtomReaderTests
//
//  Created by Inal Gotov on 2023-11-13.
//

import Foundation
@testable import AtomReader

struct MockNetworkInterface {
    func data(from url: URL) async throws -> Data {
        switch url {
        case mockFeed1.feedUrl: mockFeed1Data
        case mockFeed2.feedUrl: mockFeed2Data
        case mockFeed3.feedUrl: mockFeed3Data
            
        case mockFeed1.websiteUrl:
            """
            <!DOCTYPE html>
            <html>
            <head>
            <link rel="alternate" type="application/rss+xml" title="Hello Feed" href="https://hello.mock/feed" />
            </head>
            <body>
            </body>
            </html>
            """.data(using: .utf8)!
            
        case mockFeed2.websiteUrl:
            """
            <!DOCTYPE html>
            <html>
            <head>
            <link rel="alternate" type="application/rss+xml" title="Goodbye Feed" href="https://goodbye.mock/feed" />
            </head>
            <body>
            </body>
            </html>
            """.data(using: .utf8)!
            
        case mockFeed3.websiteUrl:
            """
            <!DOCTYPE html>
            <html>
            <head>
            <link rel="alternate" type="application/rss+xml" title="Some other Feed" href="https://something.else/feed" />
            </head>
            <body>
            </body>
            </html>
            """.data(using: .utf8)!
            
        default: throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}

extension MockNetworkInterface: FeedProviderNetworkInterface {}

extension MockNetworkInterface: FeedPreviewerNetworkInterface {
    func responseContentType(for url: URL) async throws -> String {
        switch url {
        case mockFeed1.feedUrl, mockFeed2.feedUrl, mockFeed3.feedUrl:
            return "application/rss+xml"
        case mockFeed1.websiteUrl, mockFeed2.websiteUrl, mockFeed3.websiteUrl:
            return "text/html"
        default:
            throw CocoaError(CocoaError.Code(rawValue: 0))
        }
    }
}
