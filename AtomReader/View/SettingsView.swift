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
    
    #if os(iOS)
    @State private var appIcon: AppIcon = .current
    #endif
    
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
            
            #if os(iOS)
            Section("App Icon") {
                NavigationLink {
                    AppIconPickerView(appIcon: $appIcon)
                } label: {
                    HStack {
                        Text(appIcon.displayName)
                        
                        Spacer()
                        
                        appIcon.image
                    }
                }
            }
            #endif
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
    #if os(macOS)
    SettingsView()
    #elseif os(iOS)
    NavigationStack {
        SettingsView()
    }
    #endif
}
