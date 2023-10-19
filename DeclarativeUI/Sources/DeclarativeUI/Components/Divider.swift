//
//  Divider.swift
//  
//
//  Created by Renato Cardial on 10/7/23.
//

import UIKit

/// Spacer to be used in VStack and HStack do fill space him
public class Divider: ElementView {
    
    public override var elementView: UIView { return view }
    private let view: UIView = FactoryView.makeView()
    private let lineView: UIView = FactoryView.makeView()
    private let lineHeight: CGFloat
    private lazy var constraint: ElementConstraint = .init(
        view: view,
        subview: lineView
    ).fill()
    
    /// Initialize the object that works line spacer, will be used in VStack and HStack component because
    /// the your size will be adjusted automatically to fill stack
    /// - Parameters:
    ///   - vertical: Specific size of spacer vertically
    public init(
        _ vertical: CGFloat = 1,
        color: UIColor = .lightGray,
        spacing: CGFloat = 0,
        id: String = ""
    ) {
        lineHeight = vertical
        super.init(identifier: id)
        background(color)
        constraint.height(vertical)
        space(spacing, anchors: [.top, .bottom])
    }
    
    /// Initialize the object that works line spacer, will be used in VStack and HStack component because
    /// the your size will be adjusted automatically to fill stack
    /// - Parameters:
    ///   - horizontal: Specific size of spacer horizontally
    public init(
        horizontal: CGFloat,
        color: UIColor = .lightGray,
        spacing: CGFloat = 0,
        id: String = ""
    ) {
        lineHeight = horizontal
        super.init(identifier: id)
        background(color)
        constraint.width(horizontal)
        space(spacing, anchors: [.leading, .trailing])
    }
    
    @discardableResult
    override public func background(_ color: UIColor) -> Self {
        lineView.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func space(
        _ spacing: CGFloat,
        anchors: [ElementConstraint.Anchor] = [.top, .bottom],
        animation: ElementAnimation? = nil
    ) -> Self {
        constraint.update(spacing, anchors: anchors, reference: .equal, animation: animation)
        return self
    }
    
    @discardableResult
    public func toBottom(
        _ spacing: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        space(spacing, anchors: [.top], animation: animation)
        return self
    }
    
    @discardableResult
    public func toTop(
        _ spacing: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        space(spacing, anchors: [.bottom], animation: animation)
        return self
    }
    
    @discardableResult
    public func toLeading(
        _ spacing: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        space(spacing, anchors: [.trailing], animation: animation)
        return self
    }
    
    @discardableResult
    public func toTrailing(
        _ spacing: CGFloat,
        animation: ElementAnimation? = nil
    ) -> Self {
        space(spacing, anchors: [.leading], animation: animation)
        return self
    }
    
}
