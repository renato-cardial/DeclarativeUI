//
//  ViewController.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit
import DeclarativeUI

class ViewController: Layout, RenderLayout {
    
    var body: LayoutBody {
        
        List {
            
            Text("Mensagem de Texto")
            ScrollView(horizontal: true) {
                ForEach(0..<3) { number in
                    self.create(number)
                }
            }
            .background(.systemPink)
            
            ForEach(0..<100) { number in
                Text("Row \(number)")
                    .padding(20)
                    .background(.cyan)
            }
            
        }
    }
        
    func create(_ number: Int) -> ElementView {
        if number % 2 == 0 {
            return Text("Element \(number)", id: "\(number)")
                .padding(20)
                .background(.yellow)
                .frame(width: view.frame.size.width)
        } else {
            return VStack(id: "\(number)", margin: 0, padding: 20) {
                Text("Element \(number)")
                Text("Descripton of Element")
            }
            .background(.blue)
            .frame(width: view.frame.size.width)
        }
    }
    
}
