//
//  BackyardApp.swift
//  Backyard
//
//  Created by Ho Lun Wan on 11/6/2025.
//

import SwiftUI

@main
struct BackyardApp: App {
    init() {
        Theme.current.setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            CatalogView()
        }
    }
}
