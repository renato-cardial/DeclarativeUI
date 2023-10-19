//
//  ElementView.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

/// The ElementView is the main object to use in our declarative view form to build layouts
open class ElementView: Identifiable {
    
    // MARK: - Public Properties
    
    /// Identifier the element uniquely
    public var identifier: String
    
    /// Respresent the UIView of elementView
    open var elementView: UIView { .init() }
    
    // MARK: - Internal Properties
    /// After this element to be added insider other element, this clousure will be called
    internal var afterEmbeded: [(() -> Void)]! = []
    internal var references: [AnyObject] = []
    public private(set) var children: [String: ElementView] = [:]
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    // MARK: - Methods that can be overridden
    
    func removeAllChildren() {
        children.removeAll()
    }
    
    public func addChildren(_ elements: [ElementView]) {
        elements.forEach(addChild)
    }
    
    func addChild(_ element: ElementView) {
        guard !element.identifier.isEmpty else { return }
        children.updateValue(element, forKey: element.identifier)
    }
    
    func addChildren(elements: [ElementView]) {
        elements.forEach(addChild)
    }
    
    func callAfterEmbeds() {
        afterEmbeded.forEach({ actionAfterEmbeded in
            actionAfterEmbeded()
        })
        callChildrenAfterEmbeds(children: children)
    }
    
    private func callChildrenAfterEmbeds(children: [String : ElementView]) {
        children.forEach { key, value in
            if value is Image {
                print("Break")
            }
            value.afterEmbeded.forEach { action in
                action()
            }
            callChildrenAfterEmbeds(children: value.children)
        }
    }
    
    // MARK: - Public methods can be overrided
    @discardableResult
    /**
     Define the background color to elementView
     - Parameters:
       - color: Color
    */
    public func background(_ color: UIColor) -> Self {
        elementView.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func skeleton(_ active: Bool = true) -> Self {
        guard active else {
            hideSkeleton()
            return self
        }
        
        if let vStack = self as? VStack {
            vStack.align(.leading)
        }
        
        afterEmbeded.append { [weak self] in
            guard let self = self else { return }
            let skeletons = self.skeletonViews(in: self.elementView)
            self.applySkeleton(skeletons: skeletons)
        }
        
        return self
    }
    
}

// MARK: - Public Methods
public extension ElementView {
    
    // MARK: - Dimensions
    @discardableResult
    /// Define the height of ElementView
    /// - Parameter constant: Value of height to apply
    /// - Returns: Self
    func height(_ constant: CGFloat) -> Self {
        ElementConstraint.height(constant, in: self)
        elementView.frame.size.height = constant
        return self
    }
    
    @discardableResult
    /// Define the max height of ElementView
    /// - Parameter constant: Value of max height to apply
    /// - Returns: Self
    func maxHeight(_ constant: CGFloat) -> Self {
        ElementConstraint.maxHeight(constant, in: self)
        return self
    }
    
    @discardableResult
    /// Define the min height of ElementView
    /// - Parameter constant: Value of min height to apply
    /// - Returns: Self
    func minHeight(_ constant: CGFloat) -> Self {
        ElementConstraint.minHeight(constant, in: self)
        return self
    }
   
    @discardableResult
    /// Define the width of ElementView
    /// - Parameter constant: Value of width to apply
    /// - Returns: Self
    func width(_ constant: CGFloat) -> Self {
        ElementConstraint.width(constant, in: self)
        elementView.frame.size.width = constant
        return self
    }
    
    @discardableResult
    /// Define the max width of ElementView
    /// - Parameter constant: Value of max width to apply
    /// - Returns: Self
    func maxWidth(_ constant: CGFloat) -> Self {
        ElementConstraint.maxWidth(constant, in: self)
        return self
    }
    
    @discardableResult
    /// Define the min width of ElementView
    /// - Parameter constant: Value of min width to apply
    /// - Returns: Self
    func minWidth(_ constant: CGFloat) -> Self {
        ElementConstraint.minWidth(constant, in: self)
        return self
    }
    
    @discardableResult
    /// Define frame height and width of element its equivalent to call height(_ constant: CGFloat) and width(_ constant: CGFloat)
    /// - Parameters:
    ///   - width: if passed will define this value to width else not define width
    ///   - height: if passed will define this value to height else not define height
    ///   - animation:Animate the height/width changes
    /// - Returns: Self
    func frame(width: CGFloat? = nil, height: CGFloat? = nil, animation: ElementAnimation? = nil) -> Self {
        setWidth(width)
        setHeight(height)
        animation?.animate(elementView)
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
    
    @discardableResult
    /// Animate element view
    /// - Parameter animation: Implementation of animation to apply in element view
    /// - Returns: Self
    func animate(_ animation: ElementAnimation) -> Self {
        animation.animate(elementView)
        return self
    }
    
    @discardableResult
    /// Animate elements view
    /// - Parameter animations: Implementation of animations to apply in element view
    /// - Returns: Self
    func animates(_ animations: [ElementAnimation]) -> Self {
        animations.forEach { animation in
            animation.animate(elementView)
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

// MARK: - Skeleton
// Based on Artur Chabera post
// Link: https://medium.com/@arturchabera/skeleton-view-alternative-for-loading-indicator-765d98cca2eb
private extension ElementView {
    
    var skeletonLayerName: String {
        return "skeletonLayerName"
    }

    var skeletonGradientName: String {
        return "skeletonGradientName"
    }
    
    func hideSkeleton() {
        skeletonViews(in: elementView).forEach {
            $0.layer.sublayers?.removeAll {
                $0.name == skeletonLayerName || $0.name == skeletonGradientName
            }
        }
    }
    
    func skeletonViews(in view: UIView) -> [UIView] {
        var results = [UIView]()
        
        if view.subviews.isEmpty {
            switch view {
            case _ where view.isKind(of: PaddingLabel.self):
                results += [view]
            case _ where view.isKind(of: UIImageView.self):
                results += [view]
            case _ where view.isKind(of: UIButton.self):
                results += [view]
            default: break
            }
        } else {
            
            for subview in view.subviews as [UIView] {
                switch subview {
                case _ where subview.isKind(of: PaddingLabel.self):
                    results += [subview]
                case _ where subview.isKind(of: UIImageView.self):
                    results += [subview]
                case _ where subview.isKind(of: UIButton.self):
                    results += [subview]
                default: results += skeletonViews(in: subview)
                }
                
            }
        }
        return results
    }
    
    func applySkeleton(skeletons: [UIView]) {
        elementView.layoutIfNeeded()
        
        let backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let highlightColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor

        skeletons.forEach { skeleton in
            
            let frame = skeleton.bounds
            
            let skeletonLayer = CALayer()
            skeletonLayer.backgroundColor = backgroundColor
            skeletonLayer.name = skeletonLayerName
            skeletonLayer.anchorPoint = .zero
            skeletonLayer.frame.size = frame.size
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = frame
            gradientLayer.name = skeletonGradientName

            skeleton.layer.mask = skeletonLayer
            skeleton.layer.addSublayer(skeletonLayer)
            skeleton.layer.addSublayer(gradientLayer)
            skeleton.clipsToBounds = true
            let width = frame.size.width

            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -width
            animation.toValue = width
            animation.repeatCount = .infinity
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards

            gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
        }
    }
    
}
