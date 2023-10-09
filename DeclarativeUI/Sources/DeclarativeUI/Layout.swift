//
//  Layout.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

public protocol ObservableData {}

open class Layout: UIViewController {
    
    public var layout: LayoutContent?
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        render(self as? RenderLayout)
        setStateDelegates()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        layout = nil
    }
    
    public func render(_ renderView: RenderLayout?) {
        layout = .init(view, {
            renderView
        })
    }
    
    public func get<T: ElementView>(_ identifier: String) -> T? {
        return layout?.get(identifier) as? T
    }
    
    public func get<T: ElementView>(_ identifier: String, type: T.Type) -> T? {
        return layout?.get(identifier) as? T
    }
    
    public func redraw() {
        layout?.redraw()
    }
    
    private func setStateDelegates() {
        let mirror = Mirror(reflecting: self)
        mirror.children.forEach { child in
            if let state = child.value as? BindableObjectDelegate {
                state.setDelegateBind(self)
            }
        }
    }
    
    deinit {
        print("Layout dealloced")
    }
}

extension Layout: ElementBindValueChanged {
    
    public func changed<T>(_ element: T) where T : ElementBindValueProtocol {
        layout?.redraw()
    }
    
}
