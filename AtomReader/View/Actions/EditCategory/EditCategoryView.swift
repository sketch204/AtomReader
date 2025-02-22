//
//  EditCategoryView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2025-02-22.
//

import SwiftUI

struct EditCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Store.self) private var store
    
    private let originalCategoryName: String?
    
    @State private var categoryName: String
    @State private var selectedFeeds: Set<Feed.ID> = []
    
    var canSaveCategory: Bool {
        !categoryName.isEmpty
        && !selectedFeeds.isEmpty
    }
    
    init(category: Category? = nil) {
        originalCategoryName = category?.rawValue
        _categoryName = State(wrappedValue: category?.rawValue ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Category Name", text: $categoryName)
            }
            
            Section {
                ForEach(store.feeds) { feed in
                    feedView(
                        for: feed,
                        isSelected: feedSelectionBinding(for: feed)
                    )
                }
            }
        }
        .onAppear {
            if let originalCategoryName, selectedFeeds.isEmpty {
                let originalCategory = Category(rawValue: originalCategoryName)
                selectedFeeds = Set(store.feeds(for: originalCategory).map(\.id))
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    saveCategory()
                    dismiss()
                }
                .disabled(!canSaveCategory)
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
    
    private func feedView(for feed: Feed, isSelected: Binding<Bool>) -> some View {
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
    
    private func feedSelectionBinding(for feed: Feed) -> Binding<Bool> {
        Binding {
            selectedFeeds.contains(feed.id)
        } set: { newValue in
            if selectedFeeds.contains(feed.id) {
                selectedFeeds.remove(feed.id)
            } else {
                selectedFeeds.insert(feed.id)
            }
        }
    }
    
    private func saveCategory() {
        if let originalCategoryName, originalCategoryName != categoryName {
            store.removeCategory(Category(rawValue: originalCategoryName))
        }
        
        store.setFeeds(
            selectedFeeds,
            for: Category(rawValue: categoryName)
        )
    }
}

#if DEBUG
#Preview {
    EditCategoryView()
        .environment(Store.preview())
}
#endif
