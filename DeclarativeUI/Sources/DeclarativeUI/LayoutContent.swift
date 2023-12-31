//
//  LayoutContent.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

public class LayoutContent {
    
    public var contentView: UIView = FactoryView.makeView()
    public var stackView: UIStackView = FactoryView.makeStack()
    public var ignoreSafeArea: Bool = true
    
    public lazy var margin: CGFloat = DeclarativeUISettings.LayoutContent.margin
    public lazy var padding: CGFloat = DeclarativeUISettings.LayoutContent.padding
    
    public init(
        _ mainView: UIView,
        _ completion: () -> RenderLayout?
    ) {
        guard let renderLayout = completion() else { return }
        setupView(in: mainView, elements: renderLayout.body)
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
        } else {
            setupFillView(view: contentView, subview: stackView, constant: padding)
            elements.forEach { element in
                stackView.addArrangedSubview(element.elementView)
            }
        }
    }
    
}
