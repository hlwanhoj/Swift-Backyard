//
//  SystemTextStylesView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 13/6/2025.
//

import SwiftUI
import UIKit

private struct UIKitFontTextStyle {
    let style: UIFont.TextStyle
    let name: String
}

private struct TextStyle: Identifiable {
    let id = UUID()
    let swiftUI: Font.TextStyle?
    let uiKit: UIKitFontTextStyle?
}

struct SystemTextStylesView: View {
    private let textStyles: [TextStyle] = [
        TextStyle(
            swiftUI: nil,
            uiKit: UIKitFontTextStyle(style: .extraLargeTitle, name: "extraLargeTitle")),
        TextStyle(
            swiftUI: nil,
            uiKit: UIKitFontTextStyle(style: .extraLargeTitle2, name: "extraLargeTitle2")),
        TextStyle(
            swiftUI: .largeTitle,
            uiKit: UIKitFontTextStyle(style: .largeTitle, name: "largeTitle")),
        TextStyle(
            swiftUI: .title,
            uiKit: UIKitFontTextStyle(style: .title1, name: "title1")),
        TextStyle(
            swiftUI: .title2,
            uiKit: UIKitFontTextStyle(style: .title2, name: "title2")),
        TextStyle(
            swiftUI: .title3,
            uiKit: UIKitFontTextStyle(style: .title3, name: "title3")),
        TextStyle(
            swiftUI: .headline,
            uiKit: UIKitFontTextStyle(style: .headline, name: "headline")),
        TextStyle(
            swiftUI: .subheadline,
            uiKit: UIKitFontTextStyle(style: .subheadline, name: "subheadline")),
        TextStyle(
            swiftUI: .body,
            uiKit: UIKitFontTextStyle(style: .body, name: "body")),
        TextStyle(
            swiftUI: .callout,
            uiKit: UIKitFontTextStyle(style: .callout, name: "callout")),
        TextStyle(
            swiftUI: .footnote,
            uiKit: UIKitFontTextStyle(style: .footnote, name: "footnote")),
        TextStyle(
            swiftUI: .caption,
            uiKit: UIKitFontTextStyle(style: .caption1, name: "caption1")),
        TextStyle(
            swiftUI: .caption2,
            uiKit: UIKitFontTextStyle(style: .caption2, name: "caption2")),
    ]
    
    var body: some View {
        List {
            ForEach(textStyles) { style in
                VStack(alignment: .leading, spacing: 9) {
                    SwiftUIFontTextStyleView(textStyle: style.swiftUI)
                    Color(hue: 0, saturation: 0, brightness: 0.9).frame(height: 1 / UIScreen.main.scale)
                    UIKitFontTextStyleView(textStyle: style.uiKit)
                }
                .padding(.vertical, 13)
            }
        }
        .navigationTitle("Text Styles")
    }
}

private struct SwiftUIFontTextStyleView: View {
    let textStyle: Font.TextStyle?
    
    var body: some View {
        HStack(alignment: .bottom) {
            if let textStyle = textStyle {
                Text("\(textStyle)").font(.system(textStyle))
            } else {
                Text("N/A")
            }
            Spacer()
            Text("SwiftUI")
                .font(.caption2)
                .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.7))
        }
    }
}

private struct UIKitFontTextStyleView: View {
    let textStyle: UIKitFontTextStyle?
    
    var body: some View {
        HStack(alignment: .top) {
            if let textStyle = textStyle {
                let font = UIFont.preferredFont(forTextStyle: textStyle.style)
                let fontInfo = [
                    "\(font.fontName) (\(String(format: "%.2f pt", font.pointSize)))",
                    "rawValue: \(textStyle.style.rawValue)",
                ]
                VStack(alignment: .leading) {
                    Text(textStyle.name).font(Font(font))
                    Text(fontInfo.joined(separator: "\n"))
                        .font(.footnote)
                        .foregroundStyle(Color.secondary)
                }
            } else {
                Text("N/A")
            }
            Spacer()
            Text("UIKit")
                .font(.caption2)
                .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.7))
        }
    }
}

#Preview {
    NavigationStack {
        SystemTextStylesView()
    }
}
