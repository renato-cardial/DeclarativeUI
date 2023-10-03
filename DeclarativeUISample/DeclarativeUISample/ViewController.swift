//
//  ViewController.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit
import DeclarativeUI

class ViewController: Layout, RenderLayout {
    
    static var teste: Bool = true
    
    var body: LayoutBody {
        
        ScrollView {
            
            Text("Mensagem de Texto", id: "textMessage")
            
            ScrollView(horizontal: true) {
                ForEach(0..<6) { number in
                    self.create(number)
                }
            }
            .background(.systemPink)
            
            ForEach(0..<20) { number in
                Text("Row \(number)")
                    .padding(20)
                    .background(.cyan)
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let textMessage: Text? = get("textMessage")
        textMessage?.text = "You can change this form or"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.get("textMessage", type: Text.self)?.text = "this form"
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
