//
//  CollectionExt.swift
//  CL01
//
//  Created by Ho Lun Wan on 5/6/2025.
//

import Foundation

public extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
