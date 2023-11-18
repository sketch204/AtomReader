//
//  SettingKeys.swift
//  AtomReader
//
//  Created by Inal Gotov on 2023-11-18.
//

enum SettingKeys {
    /// The maximum number of lines to show for each row in the article list
    static let articlePreviewMaxNumberOfLines = "articlePreviewMaxNumberOfLines"
    
    /// Whether the app should try to open articles in its own web view or default to the system browser
    static let shouldOpenArticleInApp = "shouldOpenArticleInApp"
    
    /// Whether the app should open the article web view as a push navigation or as an sheet. Has no effect if `shouldOpenArticleInApp` is false.
    static let shouldOpenArticlesInSheet = "shouldOpenArticlesInSheet"
}
