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
    lazy var textLabel: PaddingLabel = FactoryView.makeLabel()
    
    public var text: String? = nil {
        didSet {
            textLabel.text = text
        }
    }
    
    /// Initialize the Text object
    /// Parameter text: Text will be presented in this element
    public init(_ text: String?, id: String = UUID().uuidString) {
        super.init(identifier: id)
        self.textLabel.text = text
    }
    
}

// MARK: - Public Methods
public extension Text {
    
    @discardableResult
    /// Define the font size of text element
    /// - Parameter fontSize: The size value to Text font
    /// - Returns: Self
    func fontSize(_ fontSize: CGFloat) -> Self {
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        return self
    }
    
    @discardableResult
    /// Define padding to Text, this padding will be applied in all edges this element
    /// - Parameter length: padding length
    /// - Returns: Self
    func padding(_ length: CGFloat) -> Self {
        textLabel.setPadding(length)
        //textLabel.contentInset = .init(top: length, left: length, bottom: length, right: length)
        return self
    }
    
    @discardableResult
    /// Define padding to Text using insets
    /// - Parameter insets: inset padding
    /// - Returns: Self
    func padding(insets: UIEdgeInsets) -> Self {
        textLabel.setPadding(insets: insets)
        //textLabel.contentInset = insets
        return self
    }
    
    @discardableResult
    /// Define the font weight to this element
    /// - Parameter weight: The font weight for this element
    /// - Returns: Self
    func fontWeight(_ weight: UIFont.Weight?) -> Self {
        textLabel.font = UIFont.systemFont(
            //ofSize: textLabel.font?.pointSize ?? 16,
            ofSize: textLabel.font.pointSize,
            weight: weight ?? .regular
        )
        return self
    }
    
    @discardableResult
    /// Define the color to text
    /// - Parameter color: color of text
    /// - Returns: Self
    func foregroundColor(_ color: UIColor) -> Self {
        textLabel.textColor = color
        return self
    }
    
}
