//
//  CL01CategoryItem.swift
//  CL01
//
//  Created by Ho Lun Wan on 31/5/2025.
//

import Foundation

struct CL01CategoryItem: Identifiable, Hashable {
    let title: String
    let previewImageUrlString: String?

    var id: String { title }

    init(title: String, previewImageUrlString: String?) {
        self.title = title
        self.previewImageUrlString = previewImageUrlString
    }
}
