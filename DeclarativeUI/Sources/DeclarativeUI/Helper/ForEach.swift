//
//  ForEach.swift
//  
//
//  Created by Renato Cardial on 10/3/23.
//

import UIKit

public class ForEach: ElementView {
    
    public var elements: [ElementView] = []
    
    public init(_ data: Range<Int>, _ element: @escaping (Int) -> ElementView) {
        super.init(identifier: "")
        data.forEach { index in
            let item = element(index)
            elements.append(item)
        }
    }
    
    public init<T: ObservableData>(_ data: [T], _ element: @escaping (T) -> ElementView) {
        super.init(identifier: "")
        data.forEach { object in
            let item = element(object)
            elements.append(item)
        }
    }
    
    public init<T: ObservableData>(_ data: [T], _ element: @escaping (Int, T) -> ElementView) {
        super.init(identifier: "")
        data.enumerated().forEach { index, object in
            let item = element(index, object)
            elements.append(item)
        }
    }
}
