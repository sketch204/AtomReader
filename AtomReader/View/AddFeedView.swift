//
//  AddFeedView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import SwiftUI

struct AddFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Store.self) private var store
    
    @State private var feedUrlString: String = ""
    
    @State private var isLoading: Bool = false
    
    var feedUrl: URL? {
        URL(string: feedUrlString)
    }
    
    var body: some View {
        Form {
            Section("Enter the feed's URL") {
                TextField("Feed URL", text: $feedUrlString, prompt: Text("https://www.nytimes.com/feed.xml"))
                    .textContentType(.URL)
            }
            
            Button {
                addFeed()
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Add Feed")
                }
            }
            .disabled(feedUrl == nil)
            
            Section("Popular Feeds") {
                Button("Donny Wals") {
                    feedUrlString = "https://donnywals.com/feed"
                    addFeed()
                }
                
                Button("Swift by Sundell") {
                    feedUrlString = "https://swiftbysundell.com/rss"
                    addFeed()
                }
                
                Button("Inal Gotov") {
                    feedUrlString = "https://inalgotov.com/feed.xml"
                    addFeed()
                }
                
                Button("9to5 Mac") {
                    feedUrlString = "https://9to5mac.com/feed"
                    addFeed()
                }
            }
        }
        #if os(macOS)
        .padding()
        #endif
    }
    
    func addFeed() {
        guard let feedUrl else { return }
        
        isLoading = true
        
        Task {
            do {
                try await store.addFeed(at: feedUrl)
                dismiss()
            } catch {
                Logger.app.critical("Failed to add feed -- \(error)")
            }
        }
    }
}

#Preview {
    AddFeedView()
}
