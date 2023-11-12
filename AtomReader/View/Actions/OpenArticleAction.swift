//
//  OpenArticleAction.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-12.
//

import SwiftUI
import WebView

struct OpenArticleAction: AppAction, Hashable {
    let article: Article
    var shouldOpenArticleInApp: Bool?
    var shouldOpenArticlesInSheet: Bool?
}

fileprivate struct OpenArticleActionHandler: ViewModifier {
    @AppStorage("shouldOpenArticleInApp") private var shouldOpenArticleInApp: Bool = true
    @AppStorage("shouldOpenArticlesInSheet") private var shouldOpenArticlesInSheet: Bool = false
    
    @Environment(AppActions.self) private var appActions
    @Environment(\.openURL) private var openUrl
    
    @State private var viewedArticle: Article?
    
    private var navigationPathBinding: Binding<NavigationPath>?
    
    init(navigationPathBinding: Binding<NavigationPath>? = nil) {
        self.navigationPathBinding = navigationPathBinding
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(appActions.events(for: OpenArticleAction.self)) { action in
                handleAction(action)
            }
            .sheet(item: $viewedArticle) { article in
                WebView(url: article.articleUrl)
                    .frame(minWidth: 800, minHeight: 600)
                    .toolbar {
                        Button("Close") {
                            viewedArticle = nil
                        }
                    }
            }
            .navigationDestination(for: OpenArticleAction.self) { action in
                WebView(url: action.article.articleUrl)
                    .ignoresSafeArea(.container, edges: .bottom)
                    .navigationBarTitleDisplayMode(.inline)
            }
    }
    
    private func handleAction(_ action: OpenArticleAction) {
        let shouldOpenArticleInApp = action.shouldOpenArticleInApp ?? self.shouldOpenArticleInApp
        let shouldOpenArticlesInSheet = action.shouldOpenArticlesInSheet ?? self.shouldOpenArticlesInSheet
        
        if shouldOpenArticleInApp {
            if !shouldOpenArticlesInSheet, let navigationPathBinding {
                navigationPathBinding.wrappedValue.append(action)
            } else {
                viewedArticle = action.article
            }
        } else {
            openUrl(action.article.articleUrl)
        }
    }
}

extension View {
    func handleOpenArticleAction(navigationPath: Binding<NavigationPath>? = nil) -> some View {
        modifier(OpenArticleActionHandler(navigationPathBinding: navigationPath))
    }
}
