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
        super.init()
        data.forEach { number in
            let item = element(number)
            elements.append(item)
        }
    }
}
