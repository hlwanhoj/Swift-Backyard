//
//  CatalogItem.swift
//  Backyard
//
//  Created by Ho Lun Wan on 6/6/2025.
//

import Foundation

enum CatalogItemAction {
    case goToInstalledFontsPage
}

struct CatalogSection: Identifiable {
    let id = UUID()
    let name: String
    let children: [CatalogItem]
}

struct CatalogItem: Identifiable, Hashable {
    let id = UUID() // Unique identifier for diffable data sources or advanced updates
    let name: String
    let action: CatalogItemAction?
}
