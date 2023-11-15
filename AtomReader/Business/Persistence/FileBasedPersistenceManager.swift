//
//  FileBasedPersistenceManager.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

protocol PersistenceManagerIO {
    var persistenceUrl: URL { get }
    func readData(at url: URL) throws -> Data
    func writeData(_ data: Data, to url: URL) throws
}

struct FileBasedPersistenceManager {
    private let io: PersistenceManagerIO
    private var persistenceUrl: URL {
        io.persistenceUrl
    }
    
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
        
    init(io: PersistenceManagerIO = DefaultPersistenceManagerIO()) {
        self.io = io
        
        Logger.persistence.trace("Initialized FileBasedPersistenceManager. Persistence URL \(io.persistenceUrl.absoluteString, privacy: .public)")
    }
    
    func read<Value, DTO>(
        _ dtoType: DTO.Type,
        at url: URL,
        mapper: (DTO) -> Value
    ) -> Value? where DTO: Decodable {
        do {
            let data = try io.readData(at: url)
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
            try io.writeData(data, to: url)
        } catch {
            Logger.persistence.critical("Failed to write file with contents \(String(describing: value)), at \(url) -- \(error, privacy: .public)")
        }
    }
    
    private func isNoSuchFileError(_ error: Error) -> Bool {
        (error as NSError).domain == "NSCocoaErrorDomain"
        && (error as NSError).code == 260
    }
}

extension FileBasedPersistenceManager: StorePersistenceManager {
    private var feedsFileUrl: URL {
        persistenceUrl.appending(component: "feeds")
    }
    private var articlesFileUrl: URL {
        persistenceUrl.appending(component: "articles")
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
        persistenceUrl.appending(component: "readingHistory")
    }
    
    func load() async -> [ReadArticle] {
        read([ReadArticleDTO].self, at: readArticlesFileUrl, mapper: { $0.map(ReadArticle.init(from:)) }) ?? []
    }
    
    func save(_ articles: [ReadArticle]) {
        write(articles, at: readArticlesFileUrl, mapper: { $0.map(ReadArticleDTO.init(from:)) })
    }
}
