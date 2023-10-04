//
//  Text.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit



@propertyWrapper
public class State<A, B> {
    
    weak var delegate: ElementBindValueChanged?
    
    let identifier: String = UUID().uuidString
    lazy var elementBindValue: ElementBindValue<A> = .init(identifier: identifier)
    
    public var wrappedValue: A {
        didSet {
            elementBindValue.value = wrappedValue
            delegate?.changed(elementBindValue)
        }
    }
    
    public init(wrappedValue: A) where A == B {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: A {
        return wrappedValue
    }
}

protocol ElementBindValueChanged: AnyObject {
    func changed<T: ElementBindValueProtocol>(_ element: T)
}

protocol ElementBindValueProtocol {
    associatedtype Valor
    var identifier: String { get set }
    var value: Valor? { get set }
}

struct ElementBindValue<T>: ElementBindValueProtocol {
    typealias Valor = T
    var identifier: String
    var value: Valor?
}

@propertyWrapper
public class BindValue<T> {
    
    weak var delegate: ElementBindValueChanged?
    
    var elementBindValue: ElementBindValue<T> = .init(identifier: "")
    
    public init(identifier: String = UUID().uuidString, value: T? = nil) {
        self.elementBindValue.identifier = identifier
        self.elementBindValue.value = value
    }
    
    public var wrappedValue: T? {
        get {
            return elementBindValue.value
        }
        set {
            elementBindValue.value = newValue
            delegate?.changed(elementBindValue)
        }
    }
    
    public var projectedValue: T? {
        return elementBindValue.value
    }
}


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
public class Text: ElementView, UpdatedString, ElementBindValueChanged {
    
    typealias Valor = String
    
    func changed<T>(_ element: T) where T : ElementBindValueProtocol {
        textLabel.text = element.value as? String
    }
    
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
    
    public init(_ text: BindValue<String>?) {
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
