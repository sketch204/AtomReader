import Foundation
import AtomXML

public struct AtomURLResolver {
    private let parser: AtomXMLParser
    private let url: URL
    
    private init(parser: AtomXMLParser, url: URL) {
        self.parser = parser
        self.url = url
    }
    
    public init(data: Data, url: URL) {
        self.init(parser: AtomXMLParser(data: data), url: url)
    }
}

extension AtomURLResolver {
    public func findLinks() throws -> [Link] {
        let tree = try parse()
        
        guard let head = tree.childNode(name: "head") else {
            throw InvalidHTML()
        }
        
        return findLinksIn(head: head)
    }
    
    private func parse() throws -> AtomXMLNode {
        try parser.parse()
    }
    
    private func findLinksIn(head: AtomXMLNode) -> [Link] {
        head.children
            .filter { node in
                node.name == "link"
                && node.attributes["rel"] == "alternate"
                && (node.attributes["type"] == "application/rss+xml" || node.attributes["type"] == "application/atom+xml")
            }
            .compactMap { node -> Link? in
                guard let urlString = node.attributes["href"],
                      var url = URL(string: urlString)
                else { return nil }
                
                if url.scheme == nil {
                    var comps = URLComponents(url: self.url, resolvingAgainstBaseURL: false)
                    comps?.path = url.path()
                    guard let newUrl = comps?.url else { return nil }
                    url = newUrl
                }
                
                return Link(
                    url: url,
                    feedType: node.attributes["type"] == "application/rss+xml" ? .rss : .atom,
                    title: node.attributes["title"]
                )
            }
    }
}
