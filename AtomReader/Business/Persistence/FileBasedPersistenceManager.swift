//
//  FileBasedPersistenceManager.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

class FileBasedPersistenceManager {
    private let fileManager: FileManager
    private let applicationSupportUrl: URL
    
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
        
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        
        self.applicationSupportUrl = try! fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        Logger.persistence.trace("Initialized FileBasedPersistenceManager. Application Support URL \(self.applicationSupportUrl.absoluteString, privacy: .public)")
    }
    
    func read<Value, DTO>(
        _ dtoType: DTO.Type,
        at url: URL,
        mapper: (DTO) -> Value
    ) -> Value? where DTO: Decodable {
        do {
            let data = try Data(contentsOf: url)
            let dto = try decoder.decode(dtoType, from: data)
            return mapper(dto)
        } catch {
            if !isNoSuchFileError(error) {
                Logger.persistence.critical("Failed to read file at \(url) -- \(error, privacy: .public)")
            }
            return nil
        }
    }
    
    func write<Value, DTO>(
        _ value: Value,
        at url: URL,
        mapper: (Value) -> DTO
    ) where DTO: Encodable {
        do {
            let dto = mapper(value)
            let data = try encoder.encode(dto)
            try data.write(to: url)
        } catch {
            Logger.persistence.critical("ERROR: Failed to write file with contents \(String(describing: value)), at \(url) -- \(error, privacy: .public)")
        }
    }
    
    func isNoSuchFileError(_ error: Error) -> Bool {
        (error as NSError).domain == "NSCocoaErrorDomain"
        && (error as NSError).code == 260
    }
}

extension FileBasedPersistenceManager: StorePersistenceManager {
    private var feedsFileUrl: URL {
        applicationSupportUrl.appending(component: "feeds")
    }
    private var articlesFileUrl: URL {
        applicationSupportUrl.appending(component: "articles")
    }
    
    func load() async -> (feeds: [Feed], articles: [Article]) {
        let feeds = read(
            [FeedDTO].self,
            at: feedsFileUrl,
            mapper: { dtos in
                dtos.map(Feed.init(from:))
            }
        )
        let articles = read(
            [ArticleDTO].self,
            at: articlesFileUrl,
            mapper: { dtos in
                dtos.map(Article.init(from:))
            }
        )
        
        return (
            feeds ?? [],
            articles ?? []
        )
    }
    
    func save(_ feeds: [Feed]) {
        write(feeds, at: feedsFileUrl, mapper: { $0.map(FeedDTO.init(from:)) })
    }
    
    func save(_ articles: [Article]) {
        write(articles, at: articlesFileUrl, mapper: { $0.map(ArticleDTO.init(from:)) })
    }
}

extension FileBasedPersistenceManager: ReadingHistoryStorePersistenceManager {
    private var readArticlesFileUrl: URL {
        applicationSupportUrl.appending(component: "readingHistory")
    }
    
    func load() async -> [ReadArticle] {
        read([ReadArticleDTO].self, at: readArticlesFileUrl, mapper: { $0.map(ReadArticle.init(from:)) }) ?? []
    }
    
    func save(_ articles: [ReadArticle]) {
        write(articles, at: readArticlesFileUrl, mapper: { $0.map(ReadArticleDTO.init(from:)) })
    }
}
