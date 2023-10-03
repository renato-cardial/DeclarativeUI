//
//  RenderView.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import Foundation

public protocol RenderLayout {
    typealias LayoutBody = [ElementView]
    @LayoutBuilder var body: LayoutBody { get }
}
