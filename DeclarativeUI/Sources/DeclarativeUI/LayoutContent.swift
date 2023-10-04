//
//  LayoutContent.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

public class LayoutContent {
    public private(set) var rendered: Bool = false
    
    private var elementViews: [String: ElementView] = [:]
    
    public var contentView: UIView = FactoryView.makeView()
    public var stackView: UIStackView = FactoryView.makeStack()
    public var ignoreSafeArea: Bool = true
    
    public lazy var margin: CGFloat = DeclarativeUISettings.LayoutContent.margin
    public lazy var padding: CGFloat = DeclarativeUISettings.LayoutContent.padding
    private var objectReferences: [AnyObject]? = []
    
    private var renderLayout: (() -> RenderLayout?)?
    private let mainView: UIView
    
    public init(
        _ mainView: UIView,
        _ completion: @escaping () -> RenderLayout?
    ) {
        self.mainView = mainView
        self.renderLayout = completion
        guard rendered == false else { return }
        redraw()
    }
    
    public func redraw() {
        guard let layout = renderLayout?() else { return }
        
        clearView()
        setupView(in: mainView, elements: layout.body)
        rendered = true
    }
    
    private func clearView() {
        objectReferences?.removeAll()
        objectReferences = nil
        objectReferences = []
        elementViews.forEach { key, value in
            value.elementView.removeFromSuperview()
        }
        elementViews.removeAll()
        
        mainView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    public func get(_ identifier: String) -> ElementView? {
        return get(identifier, elements: elementViews)
    }
    
    private func get(_ identifier: String, elements: [String: ElementView]) -> ElementView? {
        let elementList = elementViews.map { element in
            element.value
        }
        
        for element in elementList {
            if element.identifier == identifier {
                return element
            }
            
            for children in element.children {
                if children.key == identifier {
                    return children.value
                }
                
                return get(identifier, elements: children.value.children)
            }
        }
        
        return nil
    }
    
    private func setupView(in view: UIView, elements: [ElementView]) {
        var verticalAlign: VerticalAlignment = .fill
        let onlyOneElement = elements.count == 1
        
        if onlyOneElement, let vstack = elements.first as? VStack {
            ignoreSafeArea = vstack._ignoreSafeArea
            verticalAlign = vstack.verticalAlign
        }
        
        let contentConstraint = ElementConstraint(
            view: view,
            subview: contentView,
            safeArea: !ignoreSafeArea
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
        
        addElements(elements)
    }
    
    private func setupFillView(view: UIView, subview: UIView, constant: CGFloat) {
        ElementConstraint(
            view: view,
            subview: subview,
            safeArea: !ignoreSafeArea
        ).fill(constant)
    }
    
    private func addElements(_ elements: [ElementView]) {
        if elements.count == 1, let element = elements.first {
            setupFillView(view: contentView, subview: element.elementView, constant: margin)
            updateElement(element)
            keepReference(element)
            element.afterEmbeded.forEach({ actionAfterEmbeded in
                actionAfterEmbeded()
            })
        } else {
            setupFillView(view: contentView, subview: stackView, constant: padding)
            elements.forEach { element in                
                stackView.addArrangedSubview(element.elementView)
                updateElement(element)
                keepReference(element)
                element.afterEmbeded.forEach({ actionAfterEmbeded in
                    actionAfterEmbeded()
                })
            }
        }
    }
    
    private func keepReference(_ element: ElementView) {
        element.references.forEach { reference in
            objectReferences?.append(reference)
        }
    }
    
    @discardableResult
    private func updateElement(_ element: ElementView) -> Bool {
        var key = element.identifier
        if key.isEmpty {
            key = UUID().uuidString
        }
        element.identifier = key
        elementViews.updateValue(element, forKey: key)
        return true
    }
}
