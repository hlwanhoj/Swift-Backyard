//
//  CGRectExt.swift
//  CL01
//
//  Created by Ho Lun Wan on 5/6/2025.
//

import Foundation

public enum CGRectHorizontalEdge {
    case top, bottom
}

public enum CGRectVerticalEdge {
    case left, right
}

public extension CGRect {
    mutating func snap(_ edge: CGRectHorizontalEdge, to rect: CGRect, edge targetEdge: CGRectHorizontalEdge, offset: CGFloat = 0) {
        switch edge {
        case .top:
            switch targetEdge {
            case .top:
                origin.y = rect.minY + offset
            case .bottom:
                origin.y = rect.maxY + offset
            }
        case .bottom:
            switch targetEdge {
            case .top:
                origin.y = rect.minY - height + offset
            case .bottom:
                origin.y = rect.maxY - height + offset
            }
        }
    }
    
    mutating func snap(_ edge: CGRectVerticalEdge, to rect: CGRect, edge targetEdge: CGRectVerticalEdge, offset: CGFloat = 0) {
        switch edge {
        case .left:
            switch targetEdge {
            case .left:
                origin.x = rect.minX + offset
            case .right:
                origin.x = rect.maxX + offset
            }
        case .right:
            switch targetEdge {
            case .left:
                origin.x = rect.minX - width + offset
            case .right:
                origin.x = rect.maxX - width + offset
            }
        }
    }
}

// Helper lerp function for CGFloat
func lerp(start: CGFloat, end: CGFloat, t: CGFloat) -> CGFloat {
    return start + (end - start) * t
}

// Lerp function for CGPoint
func lerp(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint(
        x: lerp(start: start.x, end: end.x, t: t),
        y: lerp(start: start.y, end: end.y, t: t)
    )
}

// Lerp function for CGSize
func lerp(start: CGSize, end: CGSize, t: CGFloat) -> CGSize {
    return CGSize(
        width: lerp(start: start.width, end: end.width, t: t),
        height: lerp(start: start.height, end: end.height, t: t)
    )
}

// Lerp function for CGRect
func lerp(start: CGRect, end: CGRect, t: CGFloat) -> CGRect {
    return CGRect(
        origin: lerp(start: start.origin, end: end.origin, t: t),
        size: lerp(start: start.size, end: end.size, t: t)
    )
}
