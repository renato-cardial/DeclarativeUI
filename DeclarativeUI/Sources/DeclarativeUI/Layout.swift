//
//  Layout.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

open class Layout: UIViewController {
    
    public var layout: LayoutContent?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        render(self as? RenderLayout)
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
    
    deinit {
        print("Layout dealloced")
    }
}
