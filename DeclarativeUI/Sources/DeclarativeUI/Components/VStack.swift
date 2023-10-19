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
    public var body: [ElementView] { elements().get() }
    public override var elementView: UIView { return contentView }
    public private(set) var _ignoreSafeArea: Bool = false
    public private(set) var verticalAlign: VerticalAlignment
    
    // MARK: - Internal Properties
    internal var elements: (() -> [ElementView])
    internal lazy var stackView: UIStackView = FactoryView.makeStack()
    
    // MARK: - Private Properties
    private var containerConstraint: ElementConstraint?
    private var stackConstraint: ElementConstraint?
    private var margin: CGFloat
    private var padding: CGFloat

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
        id: String = UUID().uuidString,
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
        super.init(identifier: id)
        
        stackView.spacing = spacing
        self.setupView()
    }
    
    @discardableResult
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
    
    @discardableResult
    /// Define the horizontal alignment of elements inside this Element
    /// - Parameter alignment: It's the same aligment of UIStackView
    /// - Returns: Self
    func align(_ alignment: UIStackView.Alignment) -> Self {
        stackView.alignment = alignment
        return self
    }
    
    @discardableResult
    /// Define the horizontal alignment of elements inside this Element
    /// - Parameter alignment: It's the same aligment of UIStackView
    /// - Returns: Self
    func distribution(_ distributionValue: UIStackView.Distribution) -> Self {
        stackView.distribution = distributionValue
        return self
    }
    
    @discardableResult
    /// Define the vertical alignment this element on your parent view
    /// - Parameter vertical: The alignment position vertically
    /// - Returns: Self
    func align(vertical: VerticalAlignment) -> Self {
        self.verticalAlign = vertical
        return self
    }
    
    @discardableResult
    /// Define the space between the edge of parent view
    /// - Parameters:
    ///   - marginValue: Space value to margin
    ///   - animated: Change margin with animation
    ///   - animationDuration: Duration of animation
    /// - Returns: Self
    func margin(
        _ marginValue: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        self.margin = marginValue
        containerConstraint?.update(
            marginValue,
            anchors: ElementConstraint.Anchor.fill,
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border of this element
    /// - Parameters:
    ///   - paddingValue: Space value to padding
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        _ paddingValue: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        self.padding = paddingValue
        
        stackConstraint?.update(
            paddingValue,
            anchors: ElementConstraint.Anchor.fill,
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border vertically of this element
    /// - Parameters:
    ///   - vertical: Space value to padding in vertical position
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        vertical: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        stackConstraint?.update(
            vertical,
            anchors: [.top, .bottom],
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border horizontal of this element
    /// - Parameters:
    ///   - horizontal: Space value to padding in horizontal position
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        horizontal: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        stackConstraint?.update(
            horizontal,
            anchors: [.leading, .trailing],
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border horizontal of this element
    /// - Parameters:
    ///   - paddingValue: Space value to padding in anchor positions position
    ///   - anchors: The positions to apply paddingValue
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        _ paddingValue: CGFloat,
        anchors: [ElementConstraint.Anchor],
        animation: ElementAnimation? = nil
    ) -> Self {
        stackConstraint?.update(
            paddingValue,
            anchors: anchors,
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border horizontal of this element
    /// - Parameters:
    ///   - topAndHorizontal: Space value to padding in leading, trailing and top
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        topAndHorizontal: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        stackConstraint?.update(
            topAndHorizontal,
            anchors: [.leading, .trailing, .top],
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define the space between the content and the border horizontal of this element
    /// - Parameters:
    ///   - bottomAndHorizontal: Space value to padding in leading, trailing and top
    ///   - animation: The configuration to animate padding constraints
    /// - Returns: Self
    func padding(
        bottomAndHorizontal: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        stackConstraint?.update(
            bottomAndHorizontal,
            anchors: [.leading, .trailing, .bottom],
            reference: .equal,
            animation: animation
        )
        return self
    }
    
    @discardableResult
    /// Define spacing between elements on stack
    /// - Parameter space: Space between elements
    /// - Returns: Self
    func spacing(_ space: CGFloat) -> Self {
        stackView.spacing = space
        return self
    }
    
    @discardableResult
    /// When called this method the constraints of this element will not consider safeArea
    /// - Returns: Self
    func ignoreSafeArea() -> Self {
        _ignoreSafeArea = true
        return self
    }
}

// MARK: - Private Methods
private extension VStack {
    
    func addElement(_ element: ElementView) {
        stackView.addArrangedSubview(element.elementView)
        addChild(element)        
    }
    
    func setupView()  {
        setupAlignment()
        setupConstraints()
        addElements(elements().get())
    }
    
    func addElements(_ elements: [ElementView]) {
        elements.forEach(addElement)
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
        stackConstraint = ElementConstraint(
            view: containerView,
            subview: stackView
        ).fill(padding)
        
        let containerConstraint = ElementConstraint(
            view: contentView,
            subview: containerView,
            safeArea: !_ignoreSafeArea
        )
        
        switch verticalAlign {
        case .top:
            containerConstraint.onTop(margin)
        case .middle:
            containerConstraint.onMiddle(margin)
        case .bottom:
            containerConstraint.onBottom(margin)
        case .center:
            containerConstraint.center()
        case .fill:
            containerConstraint.fill(margin)
        }
        
        self.containerConstraint = containerConstraint
    }
}
