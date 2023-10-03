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
        VStack {
            Text("First element")
            Text("Second element")
        }
    }

}

