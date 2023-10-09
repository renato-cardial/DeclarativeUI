//
//  State.swift
//  
//
//  Created by Renato Cardial on 10/7/23.
//

import Foundation

@propertyWrapper
public class State<A, B>: BindableObjectDelegate {
    
    weak var delegate: ElementBindValueChanged?
    
    let identifier: String = UUID().uuidString
    lazy var elementBindValue: ElementBindValue<A> = .init(identifier: identifier)
    
    public var wrappedValue: A {
        didSet {
            elementBindValue.value = wrappedValue
            delegate?.changed(elementBindValue)
        }
    }
    
    public init(wrappedValue: A) where A == B {
        self.wrappedValue = wrappedValue
    }
    
    public var projectedValue: A {
        return wrappedValue
    }
    
    public func setDelegateBind(_ delegate: ElementBindValueChanged?) {
        self.delegate = delegate
    }
}
