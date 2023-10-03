//
//  LayoutBuilder.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

@resultBuilder
public struct LayoutBuilder {
    
    public static func buildBlock(_ components: [ElementView]...) -> [ElementView] {
        components.forEach { elements in
            elements.forEach { element in
                //print(element.elementView.description)
            }
        }
        return components.flatMap({ $0 })
    }
    
    public static func buildExpression(_ expression: ElementView) -> [ElementView] {
        [expression]
    }
    
    public static func buildExpression(_ expression: [ElementView]) -> [ElementView] {
        expression
    }
    
    public static func buildOptional(_ components: [ElementView]?) -> [ElementView] {
        components ?? []
    }
    
    /// Add support for if statements.
    public static func buildEither(first components: [ElementView]) -> [ElementView] {
        components
    }
    
    public static func buildEither(second components: [ElementView]) -> [ElementView] {
        components
    }
}
