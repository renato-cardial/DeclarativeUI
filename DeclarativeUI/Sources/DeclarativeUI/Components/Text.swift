//
//  Text.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

public protocol UpdatedString: AnyObject {
    func updated(identifier: String, value: String?)
}

@propertyWrapper
public class BindString {
    
    let identifier: String
    var value: String?
    
    weak var delegate: UpdatedString?
    
    public init(identifier: String = UUID().uuidString, value: String? = nil) {
        self.identifier = identifier
        self.value = value
    }
    
    public var wrappedValue: String? {
        get {
            return value
        }
        set {
            value = newValue
            delegate?.updated(identifier: identifier, value: value)
        }
    }
    
    public var projectedValue: String? {
        return value
    }
    
}

/// This object is responsible to present text in layout
public class Text: ElementView, UpdatedString {
    
    public override var elementView: UIView { return textLabel }
    lazy var textLabel: PaddingLabel = FactoryView.makeLabel()
    
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
    
    public init(_ text: BindString?) {
        super.init()
        text?.delegate = self
    }
    
    public func updated(identifier: String, value: String?) {
        textLabel.text = value
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
