//
//  ElementAnimation.swift
//  
//
//  Created by Renato Cardial on 10/3/23.
//

import UIKit

public class ElementAnimation {
    
    let duration: CGFloat
    let delay: CGFloat
    let options: UIView.AnimationOptions
    
    public init(
        duration: CGFloat = DeclarativeUISettings.Animation.duration,
        delay: CGFloat = 0,
        options: UIView.AnimationOptions = DeclarativeUISettings.Animation.options
    ) {
        self.duration = duration
        self.delay = delay
        self.options = options
    }
    
    public func animate(_ view: UIView) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options
        ) {
            view.layoutIfNeeded()
        }
    }
}

public extension ElementAnimation {
    
    static func defaultAnimation() -> ElementAnimation {
        return .init()
    }
    
}
