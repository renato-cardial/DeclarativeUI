//
//  Text.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

/// This object is responsible to present text in layout
public class Text: ElementView {
    
    public override var elementView: UIView { return textLabel }
    private lazy var textLabel: PaddingLabel = FactoryView.makeLabel()
    
    public var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    /// Initialize the Text object
    /// Parameter text: Text will be presented in this element
    public init(_ text: String?, id: String = "") {
        super.init()
        identifier = id
        textLabel.text = text
    }
}

// MARK: - Public Methods
public extension Text {
    
    /// Define the font size of text element
    /// - Parameter fontSize: The size value to Text font
    /// - Returns: Self
    func fontSize(_ fontSize: CGFloat) -> Self {
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        return self
    }
    
    /// Define padding to Text, this padding will be applied in all edges this element
    /// - Parameter length: padding length
    /// - Returns: Self
    func padding(_ length: CGFloat) -> Self {
        textLabel.setPadding(length)
        return self
    }
    
    /// Define the font weight to this element
    /// - Parameter weight: The font weight for this element
    /// - Returns: Self
    func fontWeight(_ weight: UIFont.Weight?) -> Self {
        textLabel.font = UIFont.systemFont(
            ofSize: textLabel.font.pointSize,
            weight: weight ?? .regular
        )
        return self
    }
}
