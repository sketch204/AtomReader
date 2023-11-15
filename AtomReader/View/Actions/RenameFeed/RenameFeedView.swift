//
//  RenameFeedView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-15.
//

import SwiftUI

struct RenameFeedView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Store.self) private var store
    
    @State private var name: String
    
    let feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
        _name = State(wrappedValue: feed.nameOverride ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("New Feed Name", text: $name, prompt: Text(feed.name))
                    .submitScope()
            } footer: {
                Text("Renaming \(feed.displayName) (\(feed.feedUrl))")
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Rename", action: rename)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel, action: { dismiss() })
            }
        }
        .onSubmit(rename)
        #if os(macOS)
        .padding()
        #endif
    }
    
    private func rename() {
        store.rename(feedId: feed.id, to: name)
        dismiss()
    }
}

#Preview {
    RenameFeedView(feed: .previewFeed1)
        .previewStore()
}
