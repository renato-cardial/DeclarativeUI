//
//  ElementConstraint.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

public class ElementConstraint {
    
    public private(set) var constraints: [NSLayoutConstraint] = []
    let subView: UIView
    let view: UIView
    
    private let autoActive: Bool
    private let safeArea: Bool
    
    public init(
        view: UIView,
        subview: UIView,
        autoActive: Bool = true,
        safeArea: Bool = false,
        forceAddSubview: Bool = false
    ) {
        self.view = view
        self.subView = subview
        self.autoActive = autoActive
        self.safeArea = safeArea
        
        if forceAddSubview {
            subview.removeFromSuperview()
        }
        
        if subview.superview == nil {
            view.addSubview(subview)
        }
    }
}

// MARK: - Public Methods
public extension ElementConstraint {
    
    func active(_ on: Bool = true) {
        constraints.forEach { constraint in
            constraint.isActive = on
        }
    }
    
    func getAnchorId(anchor: ElementConstraint.Anchor, reference: ElementConstraint.Reference) -> String {
        var axisDescription: String = ""
        switch anchor {
        case .top:
            axisDescription = subView.topAnchor.description
        case .bottom:
            axisDescription = subView.bottomAnchor.description
        case .leading:
            axisDescription = subView.leadingAnchor.description
        case .trailing:
            axisDescription = subView.trailingAnchor.description
        case .height:
            axisDescription = subView.heightAnchor.description
        case .width:
            axisDescription = subView.widthAnchor.description
        case .centerX:
            axisDescription = subView.centerXAnchor.description
        case .centerY:
            axisDescription = subView.centerYAnchor.description
        }
        
        return createIdentifier(axisDescription: axisDescription, reference: reference)
    }
    
    func update(
        _ constant: CGFloat,
        anchors: [ElementConstraint.Anchor],
        reference: ElementConstraint.Reference,
        animation: ElementAnimation? = nil
    ) {
        anchors.forEach { anchor in
            let identifier: String = getAnchorId(anchor: anchor, reference: reference)
            let constraintToUpdate = constraints.first(where: { constraint in
                constraint.identifier == identifier
            })
            
            let negativeConstant: [ElementConstraint.Anchor] = [.bottom, .trailing]
            if negativeConstant.contains(anchor) {
                constraintToUpdate?.constant = -constant
            } else {
                constraintToUpdate?.constant = constant
            }
        }
        
        if let animation = animation {
            animation.animate(subView)
        } else {
            subView.layoutIfNeeded()
        }
    }
    
    // MARK: - Base Constraints
    @discardableResult
    func top(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setYAxis(
            axis: subView.topAnchor,
            inAxis: safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func bottom(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setYAxis(
            axis: subView.bottomAnchor,
            inAxis: safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor,
            constant: -constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func leading(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setXAxis(
            axis: subView.leadingAnchor,
            inAxis: safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func trailing(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setXAxis(
            axis: subView.trailingAnchor,
            inAxis: safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor,
            constant: -constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func centerY(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setYAxis(
            axis: subView.centerYAnchor,
            inAxis: view.centerYAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func centerX(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setXAxis(
            axis: subView.centerXAnchor,
            inAxis: view.centerXAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func center(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        centerY(constant, reference: reference)
        centerX(constant, reference: reference)
        return self
    }
    
    @discardableResult
    func height(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setDimension(
            view: view.heightAnchor,
            subview: subView.heightAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat = 0, reference: ElementConstraint.Reference = .equal) -> Self {
        setDimension(
            view: view.widthAnchor,
            subview: subView.widthAnchor,
            constant: constant,
            reference: reference
        )
        return self
    }
    
    // MARK: - Custom Constraints
    @discardableResult
    func fill(_ constant: CGFloat = 0) -> Self {
        self
            .vertical(constant)
            .horizontal(constant)
        
        return self
    }
    
    @discardableResult
    func vertical(_ constant: CGFloat = 0) -> Self {
        self
            .top(constant)
            .bottom(constant)
        return self
    }
    
    @discardableResult
    func horizontal(_ constant: CGFloat = 0) -> Self {
        self
            .leading(constant)
            .trailing(constant)
        return self
    }
    
    @discardableResult
    func onTop(_ constant: CGFloat = 0, horizontalConstant: CGFloat? = nil) -> Self {
        self
            .top(constant)
            .horizontal(horizontalConstant ?? constant)
        
        return self
    }
    
    @discardableResult
    func onBottom(_ constant: CGFloat = 0, horizontalConstant: CGFloat? = nil) -> Self {
        self
            .bottom(constant)
            .horizontal(horizontalConstant ?? constant)
        
        return self
    }
    
    @discardableResult
    func onMiddle(_ constant: CGFloat = 0, centerConstant: CGFloat = 0) -> Self {
        self
            .centerY(centerConstant)
            .horizontal(constant)
        
        return self
    }
    
}

// MARK: - Private Methods
private extension ElementConstraint {
    
    func createIdentifier(axisDescription: String, reference: ElementConstraint.Reference) -> String {
        return "\(axisDescription.description)\(reference.rawValue)"
    }
    
    func setDimension(
        view: NSLayoutDimension,
        subview: NSLayoutDimension,
        constant: CGFloat,
        reference: ElementConstraint.Reference
    ) {
        var constraint: NSLayoutConstraint!
        switch reference {
        case .equal:
            constraint = subview.constraint(equalTo: view, constant: constant)
        case .less:
            constraint = subview.constraint(lessThanOrEqualTo: view, constant: constant)
        case .greater:
            constraint = subview.constraint(equalTo: view, constant: constant)
        }
        
        if autoActive {
            constraint.isActive = true
        }
        
        constraint.identifier = createIdentifier(axisDescription: subview.description, reference: reference)
        
        constraints.append(constraint)
    }
    
    func setAxis<T: AnyObject>(
        _ type: T.Type,
        axis: NSLayoutAnchor<T>,
        inAxis: NSLayoutAnchor<T>,
        constant: CGFloat,
        reference: ElementConstraint.Reference
    ) {
        var constraint: NSLayoutConstraint!
        
        switch reference {
        case .equal:
            constraint = axis.constraint(equalTo: inAxis, constant: constant)
        case .less:
            constraint = axis.constraint(lessThanOrEqualTo: inAxis, constant: constant)
        case .greater:
            constraint = axis.constraint(equalTo: inAxis, constant: constant)
        }
        
        constraint.identifier = createIdentifier(axisDescription: axis.description, reference: reference)
        
        if autoActive {
            constraint.isActive = true
        }
        
        constraints.append(constraint)
    }
    
    func setYAxis(
        axis: NSLayoutYAxisAnchor,
        inAxis: NSLayoutYAxisAnchor,
        constant: CGFloat,
        reference: ElementConstraint.Reference
    ) {
        setAxis(
            NSLayoutYAxisAnchor.self,
            axis: axis,
            inAxis: inAxis,
            constant: constant,
            reference: reference
        )
    }
    
    func setXAxis(
        axis: NSLayoutXAxisAnchor,
        inAxis: NSLayoutXAxisAnchor,
        constant: CGFloat,
        reference: ElementConstraint.Reference
    ) {
        setAxis(
            NSLayoutXAxisAnchor.self,
            axis: axis,
            inAxis: inAxis,
            constant: constant,
            reference: reference
        )
    }
    
}

// MARK: - Static Methods to help constraint
public extension ElementConstraint {
    
    // MARK: - Dimension Constraints
    static func dimension(
        _ constant: CGFloat,
        in layoutDimension: NSLayoutDimension,
        element: ElementView,
        reference: ElementConstraint.Reference = .equal
    ) {
        
        guard constant != .infinity else {
            if let elementConstraint = getElementConstraintInfinityValue(constant, element: element) {
                if layoutDimension == element.elementView.heightAnchor {
                    elementConstraint.height()
                } else {
                    elementConstraint.width()
                }
            }
            return
        }
        
        switch reference {
        case .equal:
            layoutDimension.constraint(equalToConstant: constant).isActive = true
        case .less:
            layoutDimension.constraint(lessThanOrEqualToConstant: constant).isActive = true
        case .greater:
            layoutDimension.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        }
    }
    
    static func getElementConstraintInfinityValue(_ value: CGFloat, element: ElementView) -> ElementConstraint? {
        if value == .infinity {
            if let superView = element.elementView.superview {
                return ElementConstraint(view: superView, subview: element.elementView)
            }
        }
        return nil
    }
    
    static func height(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.heightAnchor,
            element: element,
            reference: .equal
        )
    }
    
    static func maxHeight(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.heightAnchor,
            element: element,
            reference: .less
        )
    }
    
    static func minHeight(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.heightAnchor,
            element: element,
            reference: .greater
        )
    }
    
    static func width(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.widthAnchor,
            element: element,
            reference: .equal
        )
    }
    
    static func maxWidth(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.widthAnchor,
            element: element,
            reference: .less
        )
    }
    
    static func minWidth(_ constant: CGFloat, in element: ElementView) {
        dimension(
            constant,
            in: element.elementView.widthAnchor,
            element: element,
            reference: .greater
        )
    }
    
    static func size(_ cgSize: CGSize, in element: ElementView) {
        height(cgSize.height, in: element)
        width(cgSize.width, in: element)
    }
    
}

// MARK: - Enums
public extension ElementConstraint {
    
    enum Reference: String {
        case equal
        case less
        case greater
    }
    
    enum Anchor {
        case top
        case bottom
        case leading
        case trailing
        case height
        case width
        case centerX
        case centerY
        
        public static var fill: [Anchor] {
            return [.top, .bottom, .leading, .trailing]
        }
        
    }
}
