//
//  FileBasedPersistenceManager.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import Foundation

class FileBasedPersistenceManager {
    private static let feedsFileName: String = "feeds"
    private static let articlesFileName: String = "articles"

    private let fileManager: FileManager
    private let applicationSupportUrl: URL
    
    private var feedsFileUrl: URL {
        applicationSupportUrl.appending(component: Self.feedsFileName)
    }
    private var articlesFileUrl: URL {
        applicationSupportUrl.appending(component: Self.articlesFileName)
    }
    
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
        
        print("Initialized FileBasedPersistenceManager. Application Support URL \(applicationSupportUrl.absoluteString)")
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
                print("ERROR: Failed to read file at \(url) -- \(error)")
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
            print("ERROR: Failed to write file with contents \(value), at \(url) -- \(error)")
        }
    }
    
    func isNoSuchFileError(_ error: Error) -> Bool {
        (error as NSError).domain == "NSCocoaErrorDomain"
        && (error as NSError).code == 260
    }
}

extension FileBasedPersistenceManager: StorePersistenceManager {
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
