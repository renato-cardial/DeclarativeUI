//
//  ScrollView.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

/**
All content inside this component will be presented in a scroll

Example of use:
 ```
ScrollView {
     VStack {
        Text("First Element")
        Text("Second Element")
     }
}
```
*/
public class ScrollView: ElementView, RenderLayout {
    
    // MARK: - Public Properties
    public override var elementView: UIView { return scrollView }
    public var body: [ElementView] { elements }
    
    // MARK: - Internal Properties
    internal var contentStackView: UIStackView = FactoryView.makeStack(alignment: .fill)
    internal var scrollView: UIScrollView = FactoryView.makeScrollView()
    internal var contentView: UIView = FactoryView.makeView()
    
    // MARK: - Private Properties
    private let fillScreen: Bool
    private let horizontal: Bool
    private let spacing: CGFloat
    
    private var elements: [ElementView] = []
    private var blockElements: (() -> [ElementView])
    
    // MARK: - Initializer
    
    /// All content inside this component will be presented in a scroll
    /// - Parameters:
    ///   - fillScreen: If true the content will fill all the height ScrollView
    ///   - horizontal: Change the scroll to horizontal position
    ///   - spacing: Define spacing between elements on scroll
    ///   - _:  Closure where you will put the elementViews to scroll, is recomended use only one element link VStack, List or others that works like container of the others elements
    public init(
        _ fillScreen: Bool = false,
        horizontal: Bool = false,
        spacing: CGFloat = 0,
        id: String = UUID().uuidString,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        self.blockElements = elements
        self.fillScreen = fillScreen
        self.horizontal = horizontal
        self.spacing = spacing
        super.init(identifier: id)
        setupView()
    }
}

// MARK: - Public Methods
public extension ScrollView {
    
    @discardableResult
    /// Enable or not paging on scroll
    /// - Parameter enable: Enable or Not
    /// - Returns: Self
    func pageEnabled(_ enable: Bool = true) -> Self {
        scrollView.isPagingEnabled = enable
        return self
    }
    
    @discardableResult
    /// Show or not horizontal indicator on scroll
    /// - Parameter on: Show or Not
    /// - Returns: Self
    func horizontalIndicator(_ on: Bool = true) -> Self {
        scrollView.showsHorizontalScrollIndicator = on
        return self
    }
    
    @discardableResult
    /// show or not vertical indicator on scroll
    /// - Parameter on: Show or Not
    /// - Returns: Self
    func verticalIndicator(_ on: Bool = true) -> Self {
        scrollView.showsVerticalScrollIndicator = on
        return self
    }
    
    @discardableResult
    /// Define spacing between elements on scrollview
    /// - Parameter space: Show or Not
    /// - Returns: Self
    func spacing(_ space: CGFloat) -> Self {
        contentStackView.spacing = space
        return self
    }
}

// MARK: - Private Methods
private extension ScrollView {
    
    func setupView()  {
        elements = blockElements().get()
        
        let haveOnlyOneElement = elements.count == 1
        let firstElementVStack = elements.first as? VStack
        
        if haveOnlyOneElement, let element = firstElementVStack {
            setupConstraints(view: element.elementView)
            return
        }
        
        contentStackView.spacing = spacing
        
        if horizontal {
            contentStackView.axis = .horizontal
        }
        
        setupConstraints(view: contentStackView)
        elements.forEach { element in
            addChild(element)
            contentStackView.addArrangedSubview(element.elementView)
        }
    }
    
    func setupConstraints(view: UIView) {
        let viewConstraint = ElementConstraint(view: scrollView, subview: view, safeArea: false)
            .fill()
            
        if !horizontal {
            viewConstraint.centerX()
        } else {
            scrollView.isPagingEnabled = true
        }
        
        if fillScreen || horizontal {
            viewConstraint.heightToParent(reference: .greater)
        }
    }
}
