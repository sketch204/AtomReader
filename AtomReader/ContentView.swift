//
//  ContentView.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-10.
//

import SwiftUI
import AtomParser

struct ContentView: View {
    @State private var url: String = ""
    @State private var feed: Feed?
    
    var body: some View {
        Form {
            TextField("URL", text: $url)
            
            Text(feed != nil ? "Parsed": "Parsing")
            
            Button("Submit", action: submitForm)
        }
    }
    
    private func submitForm() {
        guard let url = URL(string: url) else { return }
        
        Task.detached(priority: .userInitiated) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
//                print(String(data: data, encoding: .utf8)!)
                
                feed = try Feed(data: data)
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
