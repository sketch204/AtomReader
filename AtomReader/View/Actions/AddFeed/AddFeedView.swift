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
                    .labelsHidden()
                    .textContentType(.URL)
                    .autocorrectionDisabled()
                    #if os(iOS)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                    #endif
            }
            
            Section {
                ForEach(viewModel.feedPreviews) { feed in
                    feedView(for: feed, isSelected: Binding {
                        viewModel.isFeedSelected(feed)
                    } set: { newValue in
                        viewModel.setFeed(feed, selected: newValue)
                    })
                    .disabled(viewModel.isFeedAlreadyAdded(feed))
                }
            } header: {
                if !viewModel.feedPreviews.isEmpty {
                    Text("Found Feeds")
                }
            } footer: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .help(errorMessage)
                }
            }
            .animation(.default, value: viewModel.feedPreviews)
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
    
    func feedView(for feed: Feed, isSelected: Binding<Bool>) -> some View {
        #if os(macOS)
        Toggle(feed.displayName, isOn: isSelected)
            .toggleStyle(.checkbox)
        #elseif os(iOS)
        Button {
            isSelected.wrappedValue.toggle()
        } label: {
            HStack {
                Text(feed.displayName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if isSelected.wrappedValue {
                    Spacer()
                    
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
        }
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
