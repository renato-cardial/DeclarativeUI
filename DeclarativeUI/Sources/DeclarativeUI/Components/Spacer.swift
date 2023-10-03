//
//  Spacer.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

/// Spacer to be used in VStack and HStack do fill space him
public class Spacer: ElementView {
    
    public override var elementView: UIView { return view }
    private lazy var view: UIView = FactoryView.makeView()
    
    /// Initialize the object that works line spacer, will be used in VStack and HStack component because
    /// the your size will be adjusted automatically to fill stack
    /// - Parameters:
    ///   - vertical: Specific size of spacer vertically
    ///   - horizontal: Specific size of spacer horizontally
    init(
        vertical: CGFloat? = nil,
        horizontal: CGFloat? = nil,
        id: String = UUID().uuidString
    ) {
        super.init()
        self.identifier = id
        frame(width: horizontal, height: vertical)
    }
}
