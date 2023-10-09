//
//  Bindable.swift
//  
//
//  Created by Renato Cardial on 10/8/23.
//

import Foundation

public protocol BindableObjectDelegate {
    func setDelegateBind(_ delegate: ElementBindValueChanged?)
}

public protocol ElementBindValueChanged: AnyObject {
    func changed<T: ElementBindValueProtocol>(_ element: T)
}

public protocol ElementBindValueProtocol {
    associatedtype Valor
    var identifier: String { get set }
    var value: Valor? { get set }
}

public struct ElementBindValue<T>: ElementBindValueProtocol {
    public typealias Valor = T
    public var identifier: String
    public var value: Valor?
}
