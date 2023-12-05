//
//  Feed+Preview.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

extension Feed {
    static let previewFeed1 = Self(
        name: "Super feed",
        description: "This feed is super serious.",
        iconUrl: URL(string: "https://www.donnywals.com/wp-content/uploads/cropped-site-icon-32x32.png"),
        websiteUrl: URL(string: "https://super.serious")!,
        feedUrl: URL(string: "https://super.serious/feed.xml")!
    )
    static let previewFeed1Data = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" >
        <link href="https://super.serious/feed.xml" rel="self" type="application/atom+xml" />
        <link href="https://super.serious" rel="alternate" type="text/html" />
        <updated>2023-10-17T01:24:18+00:00</updated>
        <id>https://super.serious</id>
        <title type="html">Super Feed</title>
        <subtitle>This feed is super serious</subtitle>
        <entry>
            <title type="html">Something happened!</title>
            <published>2023-09-07T00:00:00+00:00</published>
            <updated>2023-09-07T00:00:00+00:00</updated>
            <id>https://super.serious/1</id>
            <author>
                <name>Super serious dude</name>
            </author>
        </entry>
        <entry>
            <title type="html">Something else happened!</title>
            <published>2023-09-07T00:00:00+00:00</published>
            <updated>2023-09-07T00:00:00+00:00</updated>
            <id>https://super.serious/2</id>
            <author>
                <name>Super serious dude</name>
            </author>
        </entry>
    </feed>
    """.data(using: .utf8)!
    
    static let previewFeed1Html = """
    <!DOCTYPE html>
    <html>
    <head>
    <link rel="alternate" type="application/rss+xml" title="Super Feed" href="https://super.serious/feed.xml" />
    </head>
    <body>
    </body>
    </html>
    """
    
    static let previewFeed2 = Self(
        name: "Chillax",
        description: "This feed is anything but serious. Only good vibes here.",
        iconUrl: URL(string: "https://9to5mac.com/wp-content/uploads/sites/6/2019/10/cropped-cropped-mac1-1.png?w=32"),
        websiteUrl: URL(string: "https://super.chill")!,
        feedUrl: URL(string: "https://super.chill/feed.rss")!
    )
    static let previewFeed2Data = """
    <?xml version="1.0" encoding="utf-8"?>
    <feed xmlns="http://www.w3.org/2005/Atom" >
        <link href="https://super.chill/feed.rss" rel="self" type="application/atom+xml" />
        <link href="https://super.chill" rel="alternate" type="text/html" />
        <updated>2023-10-17T01:24:18+00:00</updated>
        <id>https://super.chill</id>
        <title type="html">Chillax</title>
        <subtitle>This feed is anything but serious. Only good vibes here.</subtitle>
        <entry>
            <title type="html">I think I thing happened?</title>
            <published>2023-09-07T00:00:00+00:00</published>
            <updated>2023-09-07T00:00:00+00:00</updated>
            <id>https://super.chill/1</id>
            <author>
                <name>Some dude</name>
            </author>
        </entry>
    </feed>
    """.data(using: .utf8)!
    
    static let previewFeed2Html = """
    <!DOCTYPE html>
    <html>
    <head>
    <link rel="alternate" type="application/rss+xml" title="Chillax" href="https://super.chill/feed.rss" />
    </head>
    <body>
    </body>
    </html>
    """
    
    static let previewFeeds: [Self] = [previewFeed1, previewFeed2]
}
