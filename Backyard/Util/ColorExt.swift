//
//  ColorExt.swift
//  Backyard
//
//  Created by Ho Lun Wan on 18/6/2025.
//

import Foundation
import SwiftUI

public extension Color {
    static var random: Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}
