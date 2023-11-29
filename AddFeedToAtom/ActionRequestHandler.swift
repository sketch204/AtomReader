//
//  ActionRequestHandler.swift
//  AddFeedToAtom
//
//  Created by Inal Gotov on 2023-11-23.
//

#if os(iOS)
import UIKit
import MobileCoreServices
#elseif os(macOS)
import AppKit
#endif
import UniformTypeIdentifiers

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        Task {
            let typeIdentifier = UTType.url.identifier
            
            let urlItems = context.inputItems
                .compactMap({ $0 as? NSExtensionItem })
                .compactMap({ $0.attachments })
                .flatMap({ $0 })
                .filter({ $0.hasItemConformingToTypeIdentifier(typeIdentifier) })
        
            var urls = [URL]()
            for itemProvider in urlItems {
                do {
                    guard let url = try await itemProvider.loadItem(forTypeIdentifier: typeIdentifier) as? URL else {
                        continue
                    }
                    
                    urls.append(url)
                } catch {
                    print("ERROR: Failed to load URL from item provider -- \(error)")
                }
            }
            
            guard let feedUrl = urls.first,
                  let deepLinkUrl = URL(string: "feed:\(feedUrl.absoluteString)")
            else {
                context.completeRequest(returningItems: nil)
                return
            }
            
            context.completeRequest(returningItems: []) { _ in
                context.open(deepLinkUrl)
            }
        }
    }
}
