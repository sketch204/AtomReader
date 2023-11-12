//
//  ArticleListViewModel.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import Foundation

@Observable
final class ArticleListViewModel {
    let store: Store
    var filter: ArticleFilter = .none
    
    private(set) var isLoading: Bool = false
    
    var articles: [Article] {
        let output =
            switch filter {
            case .none:
                store.articles
            case .feed(let feedId):
                store.articles(for: feedId)
            }
        return output.sorted(using: KeyPathComparator(\Article.publishedAt, order: .reverse))
    }
    
    init(store: Store, filter: ArticleFilter = .none) {
        self.store = store
        self.filter = filter
    }
    
    @MainActor
    func refresh() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            try await store.refresh()
        } catch {
            print("ERROR: Failed to refresh store -- \(error)")
        }
    }
    
    func feed(for article: Article) -> Feed {
        store.feed(for: article)
    }
}
