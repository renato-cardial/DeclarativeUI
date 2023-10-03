//
//  ElementView.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

/// The ElementView is the main object to use in our declarative view form to build layouts
public class ElementView: Identifiable {
    
    // MARK: - Public Properties
    
    /// Identifier the element uniquely
    public var identifier: String = UUID().uuidString
    
    /// Respresent the UIView of elementView
    public var elementView: UIView { .init() }
    
    // MARK: - Internal Properties
    /// After this element to be added insider other element, this clousure will be called
    internal var afterEmbeded: [(() -> Void)]! = []
    internal var references: [AnyObject] = []
    
    // MARK: - Methods that can be overridden
    /**
     Define the background color to elementView
     - Parameters:
       - color: Color
    */
    public func background(_ color: UIColor) -> Self {
        elementView.backgroundColor = color
        return self
    }
}

// MARK: - Public Methods
public extension ElementView {
    
    // MARK: - Dimensions
    
    /// Define the height of ElementView
    /// - Parameter constant: Value of height to apply
    func height(_ constant: CGFloat) { ElementConstraint.height(constant, in: self) }
    
    /// Define the max height of ElementView
    /// - Parameter constant: Value of max height to apply
    func maxHeight(_ constant: CGFloat) { ElementConstraint.maxHeight(constant, in: self) }
    
    /// Define the min height of ElementView
    /// - Parameter constant: Value of min height to apply
    func minHeight(_ constant: CGFloat) { ElementConstraint.minHeight(constant, in: self) }
    
    /// Define the width of ElementView
    /// - Parameter constant: Value of width to apply
    func width(_ constant: CGFloat) { ElementConstraint.width(constant, in: self) }
    
    /// Define the max width of ElementView
    /// - Parameter constant: Value of max width to apply
    func maxWidth(_ constant: CGFloat) { ElementConstraint.maxWidth(constant, in: self) }
    
    /// Define the min width of ElementView
    /// - Parameter constant: Value of min width to apply
    func minWidth(_ constant: CGFloat) { ElementConstraint.minWidth(constant, in: self) }
    
    @discardableResult
    /// Define frame height and width of element its equivalent to call height(_ constant: CGFloat) and width(_ constant: CGFloat)
    /// - Parameters:
    ///   - width: if passed will define this value to width else not define width
    ///   - height: if passed will define this value to height else not define height
    /// - Returns: Self
    func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
        setWidth(width)
        setHeight(height)
        return self
    }
    
    @discardableResult
    /// Define or not the max and min of width and height, the optional parameters if not passed will not be applied change for him
    /// - Parameters:
    ///   - maxWidth: Define the width limit
    ///   - maxHeight: Define the height limit
    ///   - minWidth: Define de width minimum
    ///   - minHeight: Define de height minimum
    /// - Returns: Self
    func frame(
        maxWidth: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        minWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil
    ) -> Self {
        afterEmbeded.append { [weak self] in
            guard let self = self else { return }
            
            self.setMaxWidth(maxWidth)
            self.setMaxHeight(maxHeight)
            self.setMinWidth(minWidth)
            self.setMinHeight(minHeight)
        }
        
        return self
    }
    
}

public extension Sequence where Element == ElementView {
    
    func get() -> [ElementView] {
        var elements: [ElementView] = []
        forEach { element in
            if let forEachObject = element as? ForEach {
                elements.append(contentsOf: forEachObject.elements)
            } else {
                elements.append(element)
            }
        }
        return elements
    }
    
}

// MARK: - Private Methods
private extension ElementView {
    
    // MARK: - Max Width and Height
    func setWidth(_ width: CGFloat?) {
        guard let width = width else { return }
        
        if width == .infinity {
            afterEmbeded.append { [weak self] in
                self?.width(.infinity)
            }
        } else {
            self.width(width)
        }
        
    }
    
    func setHeight(_ height: CGFloat?) {
        guard let height = height else { return }
        
        if height == .infinity {
            afterEmbeded.append { [weak self] in
                self?.height(.infinity)
            }
        } else {
            self.height(height)
        }
    }
    
    func setMaxWidth(_ maxWidth: CGFloat?) {
        guard let maxWidth = maxWidth else { return }
        self.maxWidth(maxWidth)
    }
    
    func setMaxHeight(_ maxHeight: CGFloat?) {
        guard let maxHeight = maxHeight else { return }
        self.maxHeight(maxHeight)
    }
    
    func setMinWidth(_ minWidth: CGFloat?) {
        guard let minWidth = minWidth else { return }
        self.minWidth(minWidth)
    }
    
    func setMinHeight(_ minHeight: CGFloat?) {
        guard let minHeight = minHeight else { return }
        self.minHeight(minHeight)
    }
    
}

