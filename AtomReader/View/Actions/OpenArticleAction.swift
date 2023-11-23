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
    var shouldSkipHistoryTracking: Bool = false
}

fileprivate struct OpenArticleActionHandler: ViewModifier {
    @AppStorage(SettingKeys.shouldOpenArticleInApp)
    private var shouldOpenArticleInApp: Bool = true
    @AppStorage(SettingKeys.shouldOpenArticlesInSheet)
    private var shouldOpenArticlesInSheet: Bool = false
    
    @Environment(ReadingHistoryStore.self) private var readingHistory
    @Environment(\.appActions) private var appActions
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
                ArticleView(article: article)
                    .frame(minWidth: 800, minHeight: 600)
                    .toolbar {
                        Button("Close") {
                            viewedArticle = nil
                        }
                    }
            }
            .navigationDestination(for: OpenArticleAction.self) { action in
                ArticleView(article: action.article)
                    .ignoresSafeArea(.container, edges: .bottom)
                    #if os(iOS)
                    .navigationBarTitleDisplayMode(.inline)
                    #endif
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
        
        if !action.shouldSkipHistoryTracking {
            readingHistory.mark(article: action.article, read: true)
        }
    }
}

extension OpenArticleActionHandler {
    fileprivate struct ArticleView: View {
        @Environment(\.openURL) private var openUrl
        
        let article: Article
        
        private var placement: ToolbarItemPlacement {
            #if os(macOS)
            .automatic
            #elseif os(iOS)
            .bottomBar
            #endif
        }
        
        var body: some View {
            WebView(url: article.articleUrl)
                .toolbar {
                    ToolbarItemGroup(placement: placement) {
                        #if os(iOS)
                        Spacer()
                        #endif
                        
                        ShareLink(item: article.articleUrl, message: Text(article.title))
                        
                        #if os(iOS)
                        Spacer()
                        #endif
                        
                        Button {
                            openUrl(article.articleUrl)
                        } label: {
                            Label("Open in Safari", systemImage: "safari")
                        }
                    }
                }
        }
    }
}

extension View {
    func handleOpenArticleAction(navigationPath: Binding<NavigationPath>? = nil) -> some View {
        modifier(OpenArticleActionHandler(navigationPathBinding: navigationPath))
    }
}
