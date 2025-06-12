//
//  CL01Cell.swift
//  CL01
//
//  Created by Ho Lun Wan on 3/6/2025.
//

import Foundation
import UIKit

class CL01Cell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.attributedText = newValue.map(Self.attributedTitle) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        // Apply the layout attributes without animation to stop the weird animation effect
        UIView.performWithoutAnimation {
            super.apply(layoutAttributes)
            guard let customAttributes = layoutAttributes as? CL01Attributes else {
                return
            }
            iconImageView.frame = customAttributes.iconImageFrame
            titleLabel.frame = customAttributes.titleLabelFrame
        }
    }
    
    static func attributedTitle(_ title: String) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "AvenirNext-Regular", size: UIFont.systemFontSize)!,
        ])
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray6.cgColor
            $0.clipsToBounds = true
        }
        iconImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .systemGray5
        }
    }
}
