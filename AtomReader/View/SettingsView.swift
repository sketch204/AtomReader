//
//  SettingsView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(SettingKeys.articlePreviewMaxNumberOfLines)
    private var articlePreviewMaxNumberOfLines: Int = 3
    
    @AppStorage(SettingKeys.shouldOpenArticleInApp)
    private var shouldOpenArticleInApp: Bool = true
    
    var body: some View {
        Form {
            Picker("Article Preview", selection: $articlePreviewMaxNumberOfLines) {
                ForEach(0..<6) { lines in
                    switch lines {
                    case 0: Text("None")
                    case 1: Text("\(lines) Line")
                    default: Text("\(lines) Lines")
                    }
                }
            }
            
            Picker("Open Articles", selection: $shouldOpenArticleInApp) {
                Text("In App")
                    .tag(true)
                
                Text("In Browser")
                    .tag(false)
            }
        }
        #if os(iOS)
        .navigationTitle("Settings")
        #endif
        #if os(macOS)
        .padding()
        .frame(maxWidth: 400)
        #endif
    }
}

#Preview {
    SettingsView()
}
