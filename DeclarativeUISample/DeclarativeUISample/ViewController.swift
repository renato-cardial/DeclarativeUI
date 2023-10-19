//
//  ViewController.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/2/23.
//

import UIKit
import DeclarativeUI

class ViewController: Layout, RenderLayout {
    
    var textMessage: String = ""
    var response: [Person] = []
    
    @State var isLoading: Bool = true
    
    var body: LayoutBody {
    
        List { [self] in
            /*VStack {
                Text(self.textMessage).minWidth(100)
            }
            
            ScrollView(horizontal: true) {
                ForEach(0..<6) { number in
                    self.createViewToScroll(number)
                }
            }
            .frame(width: view.frame.size.width)
            //.animate(.fadeInAnimation(duration: 0.5))
            */
            let padding: CGFloat = 10
            
            ForEach(response) { index, item in
                PersonCell(person: item, index: index)
            }.listSkeleton(numbers: 10) {
                //PersonCell(person: .init(name: "", age: 0)).body.first!
                VStack {
                    HStack {
                        Image(nil)
                            .frame(width: 80, height: 80)
                            .
                        clipShape(Circle())
                        VStack {
                            Text(nil).frame(width: 140, height: 21)
                            Text(nil).frame(width: 100, height: 21)
                        }
                    }
                    Divider()
                        .toBottom(padding)
                }
                .padding(topAndHorizontal: padding)
            }
        }.selectedRow { id, element in
            print(id)
            print(element)
        }
        //.skeleton(isLoading)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.textMessage = "Hello my friend"
            self.response = Person.random(1)
            self.isLoading = false
        }
    }
    
}

class PersonCell: ElementView, RenderLayout {
    
    private let index: Int
    private let person: Person
    private let padding: CGFloat = 10
    
    override var elementView: UIView { body.first!.elementView }
    
    var body: LayoutBody {
        VStack {
            HStack {
                Image("Naruto", id: "Renato")
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack {
                    Text("Name: \(self.person.name)")
                    Text("Age: \(self.person.age)")
                }
            }
            Divider()
                .toBottom(self.padding)
                /*.toTrailing(self.view.frame.size.width - (2 * self.padding))
                .toTrailing(0, animation: .defaultAnimation(
                    duration: 0.3,
                    delay: CGFloat(index) * 0.2)
                )*/
        }
        /*.padding(topAndHorizontal: padding)
        .background(.blue)
        .animates([
            .fadeInAnimation(duration: CGFloat(index) * 0.2),
            .changeBackgroundColor(.cyan, duration: CGFloat(index) * 0.2)
        ])*/
    }
    
    init(person: Person, id: String = UUID().uuidString, index: Int = 0) {
        self.person = person
        self.index = index
        super.init(identifier: id)
        
        addChildren(body)
    }
    
    
}
