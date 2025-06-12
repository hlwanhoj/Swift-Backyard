//
//  CL01.swift
//  CL01
//
//  Created by Ho Lun Wan on 31/5/2025.
//

import Foundation
import UIKit

protocol CL01Delegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CL01, titleForItemAt indexPath: IndexPath) -> NSAttributedString
}

class CL01: UICollectionViewLayout {
    var minimizedCellHeight: CGFloat = 60 {
        didSet {
            minimizedCellHeight = ceil(minimizedCellHeight)
        }
    }
    /// Spacing between icon image and title
    var iconTitleSpacing: CGFloat = 10 {
        didSet {
            hasBoundWidthChanged = true
            invalidateLayout()
        }
    }
    
    /// The spacing between items in the same row.
    var interItemSpacing: CGFloat = 10 {
        didSet {
            hasBoundWidthChanged = true
            invalidateLayout()
        }
    }
    
    var maxCellWidth: CGFloat? {
        didSet {
            hasBoundWidthChanged = true
            invalidateLayout()
        }
    }
    
    private var lastFocusedIndex: Int?
    private var hasBoundWidthChanged: Bool = true
    private var layoutAttributesCache: [CL01Attributes] = []
    private var contentWidth: CGFloat = 0.0
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - insets.top - insets.bottom
    }
    
    /// Content offset which erased the effect of collection view's content inset.
    private var normalizedContentOffset: CGPoint {
        guard let collectionView = collectionView else { return .zero }
        return collectionView.contentOffset.with { $0.x += collectionView.contentInset.left }
    }
        
    
    override class var layoutAttributesClass: AnyClass {
        return CL01Attributes.self
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // Thinking steps:
    // 1. Layout all the cells using the maximized size to calculate the content size of the collection view. It is important as we can move cells without modifying the content size.
    // 2. Animate the cells (from minimized to maximized) when the collection view is scrolled.
    // 3. Update the positions for the cells based on the scroll position.
    override func prepare() {
        super.prepare()
        
        // Only calculate if we have a collection view
        guard let collectionView = collectionView else { return }

        // Ensure there's at least one section
        guard collectionView.numberOfSections > 0 else { return }

        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        if hasBoundWidthChanged {
            layoutAttributesCache = []
            contentWidth = 0
                     
            var xOffset: CGFloat = 0
            
            // Step 1
            for i in 0..<numberOfItems {
                let indexPath = IndexPath(item: i, section: 0)
                let attributes = createInitialLayoutAttributes(forCellWith: indexPath, collectionView: collectionView)
                attributes.frame.origin.x = xOffset
                attributes.frameWhenMaximized.origin.x = xOffset
                layoutAttributesCache.append(attributes)
                xOffset += attributes.frameWhenMaximized.width + interItemSpacing
            }
            
            if numberOfItems > 0 {
                // Adjust contentWidth to remove the last interItemSpacing. Add space such that the last item is on the left when collection view is scrolled to the right.
                contentWidth = xOffset - interItemSpacing + (collectionView.bounds.width - collectionView.contentInset.right - layoutAttributesCache[numberOfItems - 1].frameWhenMaximized.width)
            }
            hasBoundWidthChanged = false
        }
        
        if numberOfItems > 0 {
            let contentOffset = normalizedContentOffset
            let focusedIndex: Int? = findFocusedIndex()

            if let focusedIndex = focusedIndex {
                let focusedAttributes = layoutAttributesCache[focusedIndex]
                let progress = (focusedAttributes.frameWhenMaximized.maxX - contentOffset.x) / focusedAttributes.frameWhenMaximized.width
                updateLayoutAttributes(focusedAttributes, forMaximizeProgress: progress)
                focusedAttributes.frame.snap(.right, to: focusedAttributes.frameWhenMaximized, edge: .right)
                
                // Move the cells before the focused cell towards the right
                var lastAttributes = focusedAttributes
                for i in (0..<focusedIndex).reversed() {
                    let attributes = layoutAttributesCache[i]
                    updateLayoutAttributes(attributes, forMaximizeProgress: 0)
                    attributes.frame.snap(.right, to: lastAttributes.frame, edge: .left, offset: -interItemSpacing)
                    lastAttributes = attributes
                }
                
                // Move the cells after the focused cell towards the left
                lastAttributes = focusedAttributes
                for i in focusedIndex+1..<layoutAttributesCache.count {
                    let attributes = layoutAttributesCache[i]
                    if i == focusedIndex + 1 {
                        updateLayoutAttributes(attributes, forMaximizeProgress: 1 - progress)
                    } else {
                        updateLayoutAttributes(attributes, forMaximizeProgress: 0)
                    }
                    attributes.frame.snap(.left, to: lastAttributes.frame, edge: .right, offset: interItemSpacing)
                    lastAttributes = attributes
                }
            }
            
            if contentOffset.x < 0 {
                // If the content offset is less than 0, maximize the first cell only
                var lastAttributes: CL01Attributes?
                for i in 0..<layoutAttributesCache.count {
                    let attributes = layoutAttributesCache[i]
                    if i == 0 {
                        updateLayoutAttributes(attributes, forMaximizeProgress: 1)
                    } else {
                        updateLayoutAttributes(attributes, forMaximizeProgress: 0)
                    }
                    if let last = lastAttributes {
                        attributes.frame.snap(.left, to: last.frame, edge: .right, offset: interItemSpacing)
                    } else {
                        attributes.frame.origin.x = 0
                    }
                    lastAttributes = attributes
                }
            } else if let last = layoutAttributesCache.last, contentOffset.x > last.frameWhenMaximized.minX {
                // If the content offset is greater than the last cell's frame, the last cell should be maximized
                updateLayoutAttributes(last, forMaximizeProgress: 1)
            }
        }
    }
    
    /// Find the index of the cell that is currently focused based on the content offset. If content offset is between two cells, return the index of the cell which is closest.
    private func findFocusedIndex() -> Int? {
        let contentOffset = normalizedContentOffset
        for (i, attributes) in layoutAttributesCache.enumerated() {
            if attributes.frameWhenMaximized.minX - interItemSpacing / 2 <= contentOffset.x && contentOffset.x < attributes.frameWhenMaximized.maxX + interItemSpacing / 2 {
                return i
            }
        }
        return nil
    }
    
    private func createInitialLayoutAttributes(forCellWith indexPath: IndexPath, collectionView: UICollectionView) -> CL01Attributes {
        let cellHeight: CGFloat = contentHeight
        let iconImageFrameWhenMaximized: CGRect = CGRect(origin: .zero, size: CGSize(width: cellHeight, height: cellHeight))
        var titleLabelFrameWhenMaximized: CGRect = CGRect(x: iconImageFrameWhenMaximized.maxX + iconTitleSpacing, y: 0, width: 0, height: 0)
        
        let titleConstraintedWidth: CGFloat
        if let maxCellWidth = maxCellWidth {
            titleConstraintedWidth = max(maxCellWidth - iconImageFrameWhenMaximized.width - iconTitleSpacing, 0)
        } else {
            titleConstraintedWidth = .greatestFiniteMagnitude
        }
        
        let title = (collectionView.delegate as? CL01Delegate)?.collectionView(collectionView, layout: self, titleForItemAt: indexPath)
        if let title = title {
            let width = title
                .boundingRect(
                    with: CGSize(width: titleConstraintedWidth, height: cellHeight),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil)
                .size.width
            titleLabelFrameWhenMaximized.size = CGSize(width: ceil(width), height: cellHeight)
        }

        let attributes = CL01Attributes(forCellWith: indexPath)
        attributes.frameWhenMaximized = CGRect(origin: .zero, size: CGSize(width: titleLabelFrameWhenMaximized.maxX, height: cellHeight))
        attributes.frameWhenMinimized = CGRect(origin: CGPoint(x: 0, y: (cellHeight - minimizedCellHeight) / 2), size: CGSize(width: minimizedCellHeight, height: minimizedCellHeight))
        attributes.iconImageFrameWhenMaximized = iconImageFrameWhenMaximized
        attributes.iconImageFrameWhenMinimized = CGRect(origin: .zero, size: attributes.frameWhenMinimized.size)
        attributes.titleLabelFrameWhenMaximized = titleLabelFrameWhenMaximized
        attributes.titleLabelFrameWhenMinimized = CGRect(
            origin: CGPoint(x: attributes.iconImageFrameWhenMinimized.maxX + iconTitleSpacing, y: attributes.iconImageFrameWhenMinimized.minY),
            size: CGSize(width: titleLabelFrameWhenMaximized.width, height: attributes.frameWhenMinimized.height))
        updateLayoutAttributes(attributes, forMaximizeProgress: 1)
        return attributes
    }
    
    // Step 2
    private func updateLayoutAttributes(_ attributes: CL01Attributes, forMaximizeProgress progress: CGFloat) {
        let _progress = max(0, min(progress, 1))
        attributes.frame = lerp(start: attributes.frameWhenMinimized, end: attributes.frameWhenMaximized, t: _progress)
        attributes.iconImageFrame = lerp(start: attributes.iconImageFrameWhenMinimized, end: attributes.iconImageFrameWhenMaximized, t: _progress)
        attributes.titleLabelFrame = lerp(start: attributes.titleLabelFrameWhenMinimized, end: attributes.titleLabelFrameWhenMaximized, t: _progress)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items whose frames intersect with the given rect
        for attributes in layoutAttributesCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesCache.first { $0.indexPath == indexPath }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout if the collection view's width changes,
        // as this might affect the available space if you were to implement wrapping.
        // For a simple horizontal scroll, this might not be strictly necessary
        // unless your item widths depend on the collection view's bounds.
        guard let collectionView = collectionView else { return false }
        hasBoundWidthChanged = collectionView.bounds.width != newBounds.width
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        if let collectionView = collectionView, let lastFocusedIndex = lastFocusedIndex, let attributes = layoutAttributesCache[safe: lastFocusedIndex] {
            return CGPoint(x: attributes.frameWhenMaximized.minX - collectionView.contentInset.left, y: proposedContentOffset.y)
        }
        return proposedContentOffset
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !layoutAttributesCache.isEmpty else {
            return proposedContentOffset
        }
        
        let contentOffset = normalizedContentOffset
        var offsetX: CGFloat = 0
        if contentOffset.x < 0 {
            offsetX = layoutAttributesCache.first!.frameWhenMaximized.minX
            lastFocusedIndex = 0
        } else if contentOffset.x > layoutAttributesCache.last!.frameWhenMaximized.minX {
            offsetX = layoutAttributesCache.last!.frameWhenMaximized.minX
            lastFocusedIndex = layoutAttributesCache.count - 1
        } else {
            // Therotically `focusedIndex` can always be found
            let focusedIndex: Int? = findFocusedIndex()
            if let focusedIndex = focusedIndex {
                var targetIndex = focusedIndex
                if velocity.x > 0 {
                    targetIndex += 1
                }
                // No need to handle backward case as content offset is stopped at the left of a cell
                if let attributes = layoutAttributesCache[safe: targetIndex] {
                    offsetX = attributes.frameWhenMaximized.minX
                }
                lastFocusedIndex = targetIndex
            }
        }
        return CGPoint(x: offsetX - collectionView.contentInset.left, y: proposedContentOffset.y)
    }
}
