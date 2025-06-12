//
//  CL01Attributes.swift
//  CL01
//
//  Created by Ho Lun Wan on 3/6/2025.
//

import Foundation
import UIKit

/*
 * LayoutAttributes act like a data model for the cell and should not contain any UI logic.
 */
class CL01Attributes: UICollectionViewLayoutAttributes {
    var frameWhenMaximized: CGRect = .zero
    var frameWhenMinimized: CGRect = .zero
    var iconImageFrameWhenMaximized: CGRect = .zero
    var iconImageFrameWhenMinimized: CGRect = .zero
    var iconImageFrame: CGRect = .zero
    var titleLabelFrameWhenMaximized: CGRect = .zero
    var titleLabelFrameWhenMinimized: CGRect = .zero
    var titleLabelFrame: CGRect = .zero
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let cell = object as? CL01Attributes else {
            return false
        }
        return super.isEqual(cell) && frameWhenMaximized == cell.frameWhenMaximized
            && frameWhenMinimized == cell.frameWhenMinimized
            && iconImageFrameWhenMaximized == cell.iconImageFrameWhenMaximized
            && iconImageFrameWhenMinimized == cell.iconImageFrameWhenMinimized
            && iconImageFrame == cell.iconImageFrame
            && titleLabelFrameWhenMaximized == cell.titleLabelFrameWhenMaximized
            && titleLabelFrameWhenMinimized == cell.titleLabelFrameWhenMinimized
            && titleLabelFrame == cell.titleLabelFrame
    }
}
