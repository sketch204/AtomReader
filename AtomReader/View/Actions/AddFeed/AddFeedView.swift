//
//  AddFeedView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-11.
//

import SwiftUI

struct AddFeedView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var viewModel: AddFeedViewModel
    
    var body: some View {
        Form {
            Section("New Feed URL") {
                TextField("Feed URL", text: $viewModel.feedUrlString, prompt: Text("Website or feed URL"))
                    .textContentType(.URL)
                    .labelsHidden()
            }
            
            Section {
                ForEach(viewModel.feedPreviews) { feed in
                    Button {
                        viewModel.toggleFeedSelection(feed)
                    } label: {
                        HStack {
                            Text(feed.displayName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if viewModel.isFeedSelected(feed) {
                                Spacer()
                                
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    #if os(iOS)
                    .foregroundStyle(.primary)
                    #elseif os(macOS)
                    .buttonStyle(.plain)
                    #endif
                }
            } header: {
                if viewModel.isLoading {
                    ProgressView("Loading Feeds")
                } else if !viewModel.feedPreviews.isEmpty {
                    Text("Found Feeds")
                }
            }

            
//            Section("Popular Feeds") {
//                Button("Donny Wals") {
//                    feedUrlString = "https://donnywals.com/feed"
//                    addFeed()
//                }
//                
//                Button("Swift by Sundell") {
//                    feedUrlString = "https://swiftbysundell.com/rss"
//                    addFeed()
//                }
//                
//                Button("Inal Gotov") {
//                    feedUrlString = "https://inalgotov.com/feed.xml"
//                    addFeed()
//                }
//                
//                Button("9to5 Mac") {
//                    feedUrlString = "https://9to5mac.com/feed"
//                    addFeed()
//                }
//            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    viewModel.addFeeds()
                    dismiss()
                }
                .disabled(!viewModel.canAddFeed)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
        }
        #if os(macOS)
        .padding()
        .frame(minWidth: 300)
        #elseif os(iOS)
        .navigationTitle("Add Feed")
        #endif
    }
}

#Preview {
    let view = AddFeedView(
        viewModel: AddFeedViewModel(
            store: .preview(),
            feedPreviewer: FeedPreviewer(
                feedProvider: .preview,
                networkInterface: .preview
            )
        )
    )
    
    #if os(macOS)
    return view
    #elseif os(iOS)
    return NavigationStack {
        view
    }
    #endif
}
