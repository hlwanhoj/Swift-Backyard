//
//  Theme.swift
//  Backyard
//
//  Created by Ho Lun Wan on 13/6/2025.
//

import SwiftUI

struct Theme {
    typealias TextAttributesProvider = (Theme) -> [NSAttributedString.Key: Any]
    
    struct Font {
        let name: String
        let size: CGFloat
        
        fileprivate static let styleMap: [SwiftUI.Font.TextStyle: UIFont.TextStyle] = [
            .largeTitle: .largeTitle,
            .title: .title1,
            .title2: .title2,
            .title3: .title3,
            .headline: .headline,
            .subheadline: .subheadline,
            .body: .body,
            .callout: .callout,
            .footnote: .footnote,
            .caption: .caption1,
            .caption2: .caption2
        ]
    }
    
    static var current = Theme(
        fontMap: [
            .largeTitle: Font(name: "Avenir-Heavy", size: 34),
            .headline: Font(name: "Avenir-Heavy", size: 17),
            .subheadline: Font(name: "Avenir-Heavy", size: 14),
            .body: Font(name: "Avenir-Book", size: 17),
            .footnote: Font(name: "Avenir-Book", size: 13),
            .caption2: Font(name: "Avenir-Book", size: 11),
        ],
        navigationBarLargeTitleTextAttributes: { theme in
            [
                .font: UIFontMetrics(forTextStyle: .extraLargeTitle).scaledFont(for: UIFont(name: "Avenir-Black", size: 36)!),
            ]
        },
        navigationBarTitleTextAttributes: { theme in
            [
                .font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont(name: "Avenir-Heavy", size: 17)!),
            ]
        }
    )
    
    private let fontMap: [SwiftUI.Font.TextStyle: Font]
    private let navigationBarLargeTitleTextAttributes: TextAttributesProvider
    private let navigationBarTitleTextAttributes: TextAttributesProvider
    
    func font(for style: SwiftUI.Font.TextStyle) -> SwiftUI.Font? {
        let font = fontMap[style]
        return font.map { SwiftUI.Font.custom($0.name, size: $0.size, relativeTo: style) }
    }
    
    func uiFont(for style: SwiftUI.Font.TextStyle) -> UIFont? {
        let font = fontMap[style]
        if let uiFontStyle = Font.styleMap[style] {
            return font
                .flatMap { UIFont(name: $0.name, size: $0.size) }
                .map { UIFontMetrics(forTextStyle: uiFontStyle).scaledFont(for: $0) }
        }
        return nil
    }
    
    func setupNavigationBarAppearance() {
        UINavigationBar.appearance().largeTitleTextAttributes = navigationBarLargeTitleTextAttributes(self)
        UINavigationBar.appearance().titleTextAttributes = navigationBarTitleTextAttributes(self)
    }
    
}

extension Text {
    public func themeFont(_ style: Font.TextStyle) -> Text {
        return self.font(Theme.current.font(for: style))
    }
}
