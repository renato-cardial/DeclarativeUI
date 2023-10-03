//
//  DeclarativeUISettings.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 10/2/23.
//

import Foundation

public struct DeclarativeUISettings {
    
    public struct LayoutContent {
        public static var margin: CGFloat = 0
        public static var padding: CGFloat = 0
    }
    
    public struct VStack {
        public static var margin: CGFloat = 16
        public static var padding: CGFloat = 0
        public static var verticalAlignment: VerticalAlignment = .center
        public static var spacing: CGFloat = 10
    }
    
    public struct HStack {
        public static var margin: CGFloat = 16
        public static var padding: CGFloat = 0
        public static var verticalAlignment: VerticalAlignment = .center
        public static var spacing: CGFloat = 10
    }
    
}
