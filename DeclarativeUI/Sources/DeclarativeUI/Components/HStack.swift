//
//  HStack.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

/**
 The HStack is responsable to arranges its subviews in a horizontal line.
 
 Example of use:
  ```
  HStack {
    Text("First Element")
    Text("Second Element")
  }
 ```
*/

public class HStack: VStack {
    
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
    public override init(
        id: String = UUID().uuidString,
        margin: CGFloat = DeclarativeUISettings.HStack.margin,
        padding: CGFloat = DeclarativeUISettings.HStack.padding,
        verticalAlignment: VerticalAlignment = DeclarativeUISettings.HStack.verticalAlignment,
        spacing: CGFloat = DeclarativeUISettings.HStack.spacing,
        @LayoutBuilder _ elements: @escaping () -> [ElementView]
    ) {
        super.init(
            id: id,
            margin: margin,
            padding: padding,
            verticalAlignment: verticalAlignment,
            spacing: spacing,
            elements
        )
        
        stackView.axis = .horizontal
        stackView.alignment = .top
    }
    
}
