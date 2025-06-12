//
//  CatalogView.swift
//  Backyard
//
//  Created by Ho Lun Wan on 11/6/2025.
//

import SwiftUI

struct CatalogView: View {
    private let sections: [CatalogSection] = [
        CatalogSection(name: "OS", children: [
            CatalogItem(name: "Installed Fonts", action: .goToInstalledFontsPage),
        ]),
        CatalogSection(name: "UICollectionViewLayout", children: [
            CatalogItem(name: "Custom Layout 1", action: .goToCustomLayout01Page),
        ]),
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(sections) { section in
                    Section(header: Text(section.name)) {
                        ForEach(section.children) { item in
                            NavigationLink(value: item.action) {
                                Text(item.name)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: CatalogItemAction.self) { action in
                switch action {
                case .goToInstalledFontsPage:
                    InstalledFontsView()
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
