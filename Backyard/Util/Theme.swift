//
//  Theme.swift
//  Backyard
//
//  Created by Ho Lun Wan on 13/6/2025.
//

import SwiftUI

struct Theme {
    
    
    static var current = Theme(
        fontMap: [
            .body: .custom("Avenir-Book", size: 12, relativeTo: .body),
            .body: .custom("Avenir-Book", size: 12, relativeTo: .body),
        ]
    )
    
    private let fontMap: [Font.TextStyle: Font]
}

