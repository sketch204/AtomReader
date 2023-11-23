import Foundation
import AtomXML
import RegexBuilder

public struct AtomURLResolver {
    private let string: String
    private let url: URL
    
    public init(string: String, url: URL) {
        self.string = string
        self.url = url
    }
    
    public init?(data: Data, url: URL) {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        self.init(string: string, url: url)
    }
}

extension AtomURLResolver {
    public func findLinks() throws -> [Link] {
        let linksRegex = Regex {
            "<link"
            
            OneOrMore {
                CharacterClass.whitespace
            }
            
            ZeroOrMore {
                CharacterClass.anyOf(">").inverted
            }
            
            ">"
        }
        
        let rawLinks = string.matches(of: linksRegex)
        
        return rawLinks
            .map(\.output)
            .map(String.init)
            .filter { link in
                link.contains(#"rel="alternate""#)
                && (link.contains(#"type="application/rss+xml""#) || link.contains(#"type="application/atom+xml"#))
            }
            .compactMap { rawLink -> Link? in
                extractLink(from: rawLink)
            }
    }
    
    private func extractLink(from rawLink: String) -> Link? {
        func captureRegex(for attributeName: String) -> Regex<(Substring, Substring)> {
            Regex<(Substring, Substring)> {
                attributeName
                "="
                "\""
                Capture {
                    ZeroOrMore(.reluctant) {
                        CharacterClass.any
                    }
                }
                "\""
            }
        }
        
        guard let urlStringMatch = rawLink.firstMatch(of: captureRegex(for: "href")),
              let url = URL(string: String(urlStringMatch.1))
        else {
            return nil
        }
        
        var title: String?
        if let titleStringMatch = rawLink.firstMatch(of: captureRegex(for: "title")) {
            title = String(titleStringMatch.1)
        }
        
        let resolvedUrl = resolveIfNeeded(url: url, baseUrl: self.url)
        
        return Link(
            url: resolvedUrl,
            feedType: rawLink.contains(#"type="application/rss+xml""#) ? .rss : .atom,
            title: title
        )
    }
    
    func resolveIfNeeded(url: URL, baseUrl: URL) -> URL {
        guard url.scheme == nil else { return url }
        
        var comps = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        comps?.path = url.path()
        
        guard let newUrl = comps?.url else { return url }
        
        return newUrl
    }
}
