//
//  VStack.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

/**
 The VStack is responsable to arranges its subviews in a vertical line.
 
 Example of use:
  ```
  VStack {
    Text("First Element")
    Text("Second Element")
  }
 ```
*/
public class VStack: ElementView, RenderLayout {
    
    // MARK: - Public Properties
    public var body: [ElementView] { elements() }
    public override var elementView: UIView { return contentView }
    public private(set) var _ignoreSafeArea: Bool = false
    public private(set) var verticalAlign: VerticalAlignment
    
    // MARK: - Internal Properties
    internal var elements: (() -> [ElementView])
    internal lazy var stackView: UIStackView = FactoryView.makeStack()
    
    // MARK: - Private Properties
    private var margin: CGFloat
    private var padding: CGFloat
    private var elementViews: [String: ElementView] = [:]
    private lazy var contentView: UIView = FactoryView.makeView()
    private lazy var containerView: UIView = FactoryView.makeView()
    
    // MARK: - Initializers
    
    /**
     The VStack is responsable to arranges its subviews in a vertical line.
     
    Default Values:
     
     This element use some default values, they are defined in DefaultSettingsElement.VStack
     you can change this values when start the application
     
     - Parameters:
       - margin: The space between the edge of parent view
       - padding: The space between the content and the border of this element
       - verticalAlignment: Define how content will be presented vertically on stack
       - spacing: Spacing between elements on stack
       - _ elements: Closure where you will put the elementViews to stack
    */
    public init(
        margin: CGFloat = DeclarativeUISettings.VStack.margin,
        padding: CGFloat = DeclarativeUISettings.VStack.padding,
        verticalAlignment: VerticalAlignment = DeclarativeUISettings.VStack.verticalAlignment,
        spacing: CGFloat = DeclarativeUISettings.VStack.spacing,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        self.margin = margin
        self.padding = padding
        self.verticalAlign = verticalAlignment
        self.elements = elements
        super.init()
        stackView.spacing = spacing
        self.setupView()
    }
    
    // MARK: - Override Methods
    /// Define the background color of this element
    /// - Parameter color: Color to background
    /// - Returns: Self
    public override func background(_ color: UIColor) -> Self {
        containerView.backgroundColor = color
        return self
    }
    
}

// MARK: - Public Methods
public extension VStack {
    
    /// Define the horizontal alignment of elements inside this Element
    /// - Parameter alignment: It's the same aligment of UIStackView
    /// - Returns: Self
    func align(_ alignment: UIStackView.Alignment) -> Self {
        stackView.alignment = alignment
        return self
    }
    
    /// Define the vertical alignment this element on your parent view
    /// - Parameter vertical: The alignment position vertically
    /// - Returns: Self
    func align(vertical: VerticalAlignment) -> Self {
        self.verticalAlign = vertical
        return self
    }
    
    /// Define the space between the edge of parent view
    /// - Parameter marginValue: Space value to margin
    /// - Returns: Self
    func margin(_ marginValue: CGFloat) -> Self {
        self.margin = marginValue
        return self
    }
    
    /// Define the space between the content and the border of this element
    /// - Parameter paddingValue: Space value to margin
    /// - Returns: Self
    func padding(_ paddingValue: CGFloat) -> Self {
        self.padding = paddingValue
        return self
    }
    
    /// Define spacing between elements on stack
    /// - Parameter space: Space between elements
    /// - Returns: Self
    func spacing(_ space: CGFloat) -> Self {
        stackView.spacing = space
        return self
    }
    
    /// When called this method the constraints of this element will not consider safeArea
    /// - Returns: Self
    func ignoreSafeArea() -> Self {
        _ignoreSafeArea = true
        return self
    }
}

// MARK: - Private Methods
private extension VStack {
    
    func add(_ element: ElementView) {
        stackView.addArrangedSubview(element.elementView)
        elementViews.updateValue(element, forKey: element.elementId)
        element.afterEmbeded.forEach({ actionAfterEmbeded in
            actionAfterEmbeded()
        })
    }
    
    func setupView()  {
        setupAlignment()
        setupConstraints()
        addElements(elements())
    }
    
    func addElements(_ elements: [ElementView]) {
        elements.forEach(add)
    }
    
    func setupAlignment() {
        switch verticalAlign {
        case .top:
            stackView.addArrangedSubview(.init())
        case .bottom:
            stackView.insertArrangedSubview(.init(), at: 0)
        case .center, .fill, .middle: break
        }
    }
    
    func setupConstraints() {
        ElementConstraint(view: containerView, subview: stackView)
            .fill(padding)
        
        let contentConstraint = ElementConstraint(
            view: contentView,
            subview: containerView,
            safeArea: !_ignoreSafeArea
        )
        
        switch verticalAlign {
        case .top:
            contentConstraint.onTop(margin)
        case .middle:
            contentConstraint.onMiddle(margin)
        case .bottom:
            contentConstraint.onBottom(margin)
        case .center:
            contentConstraint.center()
        case .fill:
            contentConstraint.fill(margin)
        }
    }
}
