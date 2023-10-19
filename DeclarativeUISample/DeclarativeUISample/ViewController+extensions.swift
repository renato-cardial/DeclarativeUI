//
//  ViewController+extensions.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/8/23.
//

import DeclarativeUI

extension ViewController {
    
    func createViewToScroll(_ number: Int) -> ElementView {
        let width = view.frame.size.width
        if number % 2 == 0 {
            return Text("Element \(number)", id: "\(number)")
                .padding(20)
                .background(.yellow)
                .frame(width: width)
        } else {
            return VStack(id: "\(number)", margin: 0, padding: 20) {
                Text("Element \(number)")
                Text("Descripton of Element")
            }
            .background(.blue)
            .frame(width: width)
        }
    }
}
