//
//  PaddingLabel.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

class PaddingLabel: UILabel {

    private var insets: UIEdgeInsets = .init()
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let newWidth = size.width + insets.left + insets.right
        let newHeight = size.height + insets.top + insets.bottom
        
        return .init(
            width: newWidth,
            height: newHeight
        )
    }

    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (insets.left + insets.right)
        }
    }
    
    func setPadding(_ length: CGFloat) {
        insets = .init(
            top: length,
            left: length,
            bottom: length,
            right: length
        )
    }
    
    func setPadding(insets: UIEdgeInsets) {
        self.insets = insets
    }
    
}
