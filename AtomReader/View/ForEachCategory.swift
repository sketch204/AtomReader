//
//  ForEachCategory.swift
//  AtomReader
//
//  Created by Inal Gotov on 2025-02-22.
//

import SwiftUI

struct ForEachCategory<Content>: View where Content: View {
    @Environment(Store.self) private var store
    
    @ViewBuilder var content: (Category) -> Content
    
    var body: some View {
        ForEach(store.categories) { category in
            content(category)
        }
    }
}
