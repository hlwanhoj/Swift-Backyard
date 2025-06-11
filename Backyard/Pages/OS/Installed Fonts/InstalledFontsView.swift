//
//  InstalledFontsView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 12/6/2025.
//

import SwiftUI

struct InstalledFontsView: View {
    @State private var searchText = ""
    private let fontFamilies = UIFont.familyNames.sorted()
    private let fontMap: [String: [String]]
    
    init() {
        var fontMap: [String: [String]] = [:]
        for familyName in fontFamilies {
            let fontNames = UIFont.fontNames(forFamilyName: familyName).sorted()
            fontMap[familyName] = fontNames
        }
        self.fontMap = fontMap
    }
    
    var filteredFontFamilies: [String] {
        if searchText.isEmpty {
            return fontFamilies
        } else {
            return fontFamilies.filter { fontFamily in
                fontFamily.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredFontFamilies, id: \.self) { fontFamily in
                let filteredFontNames = fontMap[fontFamily]!
                    .filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }
                    .sorted()
                if !filteredFontNames.isEmpty {
                    Section(header: Text(fontFamily)) {
                        ForEach(UIFont.fontNames(forFamilyName: fontFamily).sorted(), id: \.self) { fontName in
                            Button(action: {
                                UIPasteboard.general.string = fontName
                            }) {
                                Text(fontName)
                                    .font(.custom(fontName, size: 14))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Installed Fonts")
        .toolbar {
            Button("Configuration", systemImage: "gearshape.fill") {
            }
        }
        .searchable(text: $searchText, prompt: "Search Fonts")
    }
}

#Preview {
    InstalledFontsView()
}
