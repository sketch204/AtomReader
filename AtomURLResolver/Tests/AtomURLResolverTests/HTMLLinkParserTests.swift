import XCTest
@testable import AtomURLResolver

final class HTMLLinkParserTests: XCTestCase {
    // Find no link tags inside of head
    // Find single link tag inside of head
    // Find multiple link tags inside of head
    
    // Find no link tags in head, but an anchor tag with RSS in contents inside of body
    
    private func createHtml(head: String) -> String {
        """
        <!DOCTYPE html>
        <html>
        <head>
        \(head)
        </head>
        <body>
        </body>
        </html>
        """
    }
    
    
    func test_findLinks_whenRssLinkWithTitleProvided_findsLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" type="application/rss+xml" title="Hello Feed" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        let expectedLinks = [Link(url: "https://hello.mock/feed/", title: "Hello Feed")]
        
        XCTAssertEqual(links, expectedLinks)
    }
    
    func test_findLinks_whenRssLinkWithoutTitleProvided_findsLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" type="application/rss+xml" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        let expectedLinks = [Link(url: "https://hello.mock/feed/", title: nil)]
        
        XCTAssertEqual(links, expectedLinks)
    }
    
    func test_findLinks_whenAtomLinkWithoutTitleProvided_findsLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" type="application/atom+xml" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        let expectedLinks = [Link(url: "https://hello.mock/feed/", feedType: .atom, title: nil)]
        
        XCTAssertEqual(links, expectedLinks)
    }
    
    func test_findLinks_whenRssLinkWithoutRelProvided_doesNotFindLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link type="application/rss+xml" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        
        XCTAssertEqual(links, [])
    }
    
    func test_findLinks_whenRssLinkWithInvalidRelProvided_doesNotFindLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="canonical" type="application/rss+xml" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        
        XCTAssertEqual(links, [])
    }
    
    func test_findLinks_whenRssLinkWithoutTypeProvided_doesNotFindLink() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" href="https://hello.mock/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        
        XCTAssertEqual(links, [])
    }
    
    func test_findLinks_whenMultipleLinksProvided_findsAllLinks() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" type="application/rss+xml" title="Hello Feed" href="https://hello.mock/feed/" />
            <link rel="alternate" type="application/rss+xml" title="Hello sub-Feed" href="https://hello.mock/sub/1/feed/" />
            <link rel="alternate" type="application/rss+xml" title="Hello sub-Feed 2" href="https://hello.mock/sub/2/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        let expectedLinks = [
            Link(url: "https://hello.mock/feed/", title: "Hello Feed"),
            Link(url: "https://hello.mock/sub/1/feed/", title: "Hello sub-Feed"),
            Link(url: "https://hello.mock/sub/2/feed/", title: "Hello sub-Feed 2"),
        ]
        
        XCTAssertEqual(links, expectedLinks)
    }
    
    func test_findLinks_whenMultipleLinksProvided_ignoresInvalidLinks() throws {
        let html = createHtml(
            head: """
            <meta charset="UTF-8" />
            <link rel="canonical" href="https://hello.mock/" />
            <link rel="alternate" type="application/rss+xml" title="Hello Feed" href="https://hello.mock/feed/" />
            <link rel="alternate" type="application/rss+xml" title="Hello sub-Feed" href="https://hello.mock/sub/1/feed/" />
            <link rel="canonical" type="application/rss+xml" title="Hello sub-Feed 2" href="https://hello.mock/sub/2/feed/" />
            """
        )
        
        let sut = HTMLLinkParser(string: html)
        
        let links = try sut.findLinks()
        let expectedLinks = [
            Link(url: "https://hello.mock/feed/", title: "Hello Feed"),
            Link(url: "https://hello.mock/sub/1/feed/", title: "Hello sub-Feed"),
        ]
        
        XCTAssertEqual(links, expectedLinks)
    }
}

extension Link {
    init(url: String, feedType: FeedType = .rss, title: String?) {
        self.init(url: URL(string: url)!, feedType: feedType, title: title)
    }
}

extension Link: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url
        && lhs.feedType == rhs.feedType
        && lhs.title == rhs.title
    }
}

extension HTMLLinkParser {
    init(string: String) {
        let data = string.data(using: .utf8)!
        self.init(data: data)
    }
}
