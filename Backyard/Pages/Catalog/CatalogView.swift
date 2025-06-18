//
//  CatalogView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 11/6/2025.
//

import SwiftUI

struct CatalogView: View {
    private let sections: [CatalogSection] = [
        CatalogSection(name: "System", children: [
            CatalogItem(name: "Installed Fonts", action: .goToSystemInstalledFontsPage),
            CatalogItem(name: "Text Styles", action: .goToSystemTextStylesPage),
            CatalogItem(name: "Material", action: .goToSystemMaterialPage),
        ]),
        CatalogSection(name: "UICollectionViewLayout", children: [
            CatalogItem(name: "Custom Layout 1", action: .goToCustomLayout01Page),
        ]),
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section(header: Text(section.name).themeFont(.subheadline)) {
                        ForEach(section.children) { item in
                            NavigationLink(value: item.action) {
                                Text(item.name).themeFont(.body)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: CatalogItemAction.self) { action in
                switch action {
                case .goToSystemInstalledFontsPage:
                    SystemInstalledFontsView()
                case .goToSystemTextStylesPage:
                    SystemTextStylesView()
                case .goToSystemMaterialPage:
                    SystemMaterialView()
                case .goToCustomLayout01Page:
                    CustomLayout01View()
                }
            }
            .navigationTitle("Catalog")
        }
    }
}

#Preview {
    CatalogView()
}
