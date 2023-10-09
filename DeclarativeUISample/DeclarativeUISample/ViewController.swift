//
//  ViewController.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit
import DeclarativeUI

class ViewController: Layout, RenderLayout {
    
    @State var textMessage: String = "Hello"
    @State var response: [Person] = []
    
    var body: LayoutBody {
    
        List { [self] in
            Text($textMessage)
            
            ScrollView(horizontal: true) {
                ForEach(0..<6) { number in
                    self.createViewToScroll(number)
                }
            }
            .frame(width: view.frame.size.width)
            .frame(height: 200, animation: .defaultAnimation())
            
            let padding: CGFloat = 10
            
            ForEach(response) { index, item in
                
                VStack(id: "Item\(index)") {
                    Text("Name: \(item.name)")
                    Text("Age: \(item.age)")
                    Divider()
                        .toBottom(padding)
                        .toTrailing(self.view.frame.size.width - (2 * padding))
                        .toTrailing(0, animation: .defaultAnimation(
                            duration: 0.3,
                            delay: CGFloat(index) * 0.2)
                        )
                }
                .padding(topAndHorizontal: padding)
                .background(.blue)
                .animates([
                    .fadeInAnimation(duration: CGFloat(index) * 0.2),
                    .changeBackgroundColor(.cyan, duration: CGFloat(index) * 0.2)
                ])
            }
        }.selectedRow { id, element in
            print(id)
            print(element)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.response = Person.random(20)
        //self.textMessage = "Changed Title"
    }
    
}
