//
//  SystemInstalledFontsView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 12/6/2025.
//

import SwiftUI
import SwiftUIIntrospect

struct SystemInstalledFontsView: View {
    @State private var searchText = ""
    @State private var showsTextCopiedToast = false
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
    
    var body: some View {
        List {
            ForEach(fontFamilies, id: \.self) { fontFamily in
                let filteredFontNames = fontMap[fontFamily]!
                    .filter { searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText) }
                    .sorted()
                if !filteredFontNames.isEmpty {
                    Section(header: Text(fontFamily).themeFont(.subheadline)) {
                        ForEach(UIFont.fontNames(forFamilyName: fontFamily).sorted(), id: \.self) { fontName in
                            Button(action: {
                                UIPasteboard.general.string = fontName
                                showsTextCopiedToast = true
                            }) {
                                Text(fontName)
                                    .font(.custom(fontName, size: 18))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Installed Fonts")
        .searchable(text: $searchText, prompt: "Search Fonts")
        .alertToast(isShowing: $showsTextCopiedToast) {
            VStack {
                Image(systemName: "checkmark")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 9)
                Text("Font name copied to clipboard")
            }
            .padding(26)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 15, style: .continuous))
        }
    }
}

#Preview {
    NavigationStack {
        SystemInstalledFontsView()
    }
}
