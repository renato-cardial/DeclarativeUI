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
    private var elements: [ElementView] = []
    private var blockElements: (() -> [ElementView])
    
    // MARK: - Initializer
    
    /// All content inside this component will be presented in a scroll
    /// - Parameters:
    ///   - fillScreen: If true the content will fill all the height ScrollView
    ///   - _:  Closure where you will put the elementViews to scroll, is recomended use only one element link VStack, List or others that works like container of the others elements
    public init(
        _ fillScreen: Bool = false,
        id: String = UUID().uuidString,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        self.blockElements = elements
        self.fillScreen = fillScreen
        super.init()
        self.identifier = id
        setupView()
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
        
        setupConstraints(view: contentStackView)
        elements.forEach { element in
            contentStackView.addArrangedSubview(element.elementView)
        }
    }
    
    func setupConstraints(view: UIView) {
        let viewConstraint = ElementConstraint(view: scrollView, subview: view)
            .fill()
            .centerX()
        
        if fillScreen {
            viewConstraint.height(reference: .greater)
        }
    }
}
