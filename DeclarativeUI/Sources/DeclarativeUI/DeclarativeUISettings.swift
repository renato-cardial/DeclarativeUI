//
//  DeclarativeUISettings.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit

public struct DeclarativeUISettings {
    
    public struct LayoutContent {
        public static var margin: CGFloat = 0
        public static var padding: CGFloat = 0
    }
    
    public struct VStack {
        public static var margin: CGFloat = 16
        public static var padding: CGFloat = 0
        public static var verticalAlignment: VerticalAlignment = .fill
        public static var spacing: CGFloat = 10
    }
    
    public struct HStack {
        public static var margin: CGFloat = 16
        public static var padding: CGFloat = 0
        public static var verticalAlignment: VerticalAlignment = .fill
        public static var spacing: CGFloat = 10
    }
    
    public struct Animation {
        public static var duration: CGFloat = 0.3
        public static var options: UIView.AnimationOptions = .curveLinear
    }
    
    public struct Scroll {
        public static var bounce: Bool = false
        public static var showsHorizontalScrollIndicator: Bool = false
        public static var showsVerticalScrollIndicator: Bool = false
    }
    
}
