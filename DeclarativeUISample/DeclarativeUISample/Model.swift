//
//  Model.swift
//  DeclarativeUISample
//
//  Created by Renato Cardial on 10/8/23.
//

import DeclarativeUI

struct Person: ObservableData {
    let name: String
    let age: Int
    
    static func random(_ count: Int) -> [Person] {
        let names: [String] = [
            "Elizabeth",
            "Mike",
            "Bob",
            "Julian",
            "Tyler",
            "Tifanny",
            "Kelly",
            "Maycon",
            "Nicholas",
            "Steven",
            "Kimberly"
        ]
        
        var persons: [Person] = []
        for n in 0..<count {
            persons.append(.init(name: names.randomElement()!, age: Int.random(in: n..<70)))
        }
        return persons
    }
    
}
