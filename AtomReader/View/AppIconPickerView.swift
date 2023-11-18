//
//  AppIconPickerView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

#if os(iOS)

import SwiftUI

struct AppIconPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var appIcon: AppIcon
    
    var body: some View {
        List(AppIcon.all) { icon in
            Button {
                appIcon = icon
                AppIcon.setCurrent(icon) { error in
                    if let error {
                        Logger.app.critical("Failed to change app icon -- \(error)")
                    }
                    dismiss()
                }
            } label: {
                HStack {
                    icon.image
                    
                    Text(icon.displayName)
                    
                    if appIcon == icon {
                        Spacer()
                        
                        Image(systemName: "checkmark")
                    }
                }
            }
            .foregroundStyle(.primary)
        }
        .navigationTitle("App Icon")
    }
}

fileprivate struct TestView: View {
    @State private var icon: AppIcon = .current
    
    var body: some View {
        AppIconPickerView(appIcon: $icon)
    }
}

#Preview {
    TestView()
}

#endif
