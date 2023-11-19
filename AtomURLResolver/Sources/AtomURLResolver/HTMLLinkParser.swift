import Foundation
import AtomXML

struct HTMLLinkParser {
    private let parser: AtomXMLParser
    
    private init(parser: AtomXMLParser) {
        self.parser = parser
    }
    
    init(data: Data) {
        self.init(parser: AtomXMLParser(data: data))
    }
}

extension HTMLLinkParser {
    func findLinks() throws -> [Link] {
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
                      let url = URL(string: urlString)
                else { return nil }
                
                return Link(
                    url: url,
                    feedType: node.attributes["type"] == "application/rss+xml" ? .rss : .atom,
                    title: node.attributes["title"]
                )
            }
    }
}
