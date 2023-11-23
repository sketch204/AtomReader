import Foundation

public struct Link {
    public enum FeedType: Equatable {
        case atom
        case rss
    }
    
    public let url: URL
    public let feedType: FeedType
    public let title: String?
}
