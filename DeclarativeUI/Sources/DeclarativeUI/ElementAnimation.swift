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
    
    var animatePreAction: [((UIView) -> Void)] = []
    var animateAction: ((UIView) -> Void)?
    
    public init(
        duration: CGFloat = DeclarativeUISettings.Animation.duration,
        delay: CGFloat = 0,
        options: UIView.AnimationOptions = DeclarativeUISettings.Animation.options,
        animatePreAction: ((UIView) -> Void)? = nil,
        animateAction: ((UIView) -> Void)? = nil
    ) {
        self.duration = duration
        self.delay = delay
        self.options = options
        if let animatePreAction = animatePreAction {
            self.animatePreAction.append(animatePreAction)
        }
        self.animateAction = animateAction
    }
    
    public func animate(_ view: UIView) {
        
        if delay > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animatePreAction.forEach { preAction in
                    preAction(view)
                }
                
                UIView.animate(
                    withDuration: self.duration,
                    delay: 0,
                    options: self.options
                ) { [self] in
                    self.animateAction?(view)
                    if let superview = view.superview {
                        superview.layoutIfNeeded()
                    } else {
                        view.layoutIfNeeded()
                    }
                }
            }
        } else {
            animatePreAction.forEach { preAction in
                preAction(view)
            }
            
            UIView.animate(
                withDuration: self.duration,
                delay: self.delay,
                options: self.options
            ) { [self] in
                
                self.animateAction?(view)
                
                if let superview = view.superview {
                    superview.layoutIfNeeded()
                } else {
                    view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    public func addPreAction(_ preAction: @escaping (UIView) -> Void) {
        animatePreAction.append(preAction)
    }
    
}

public extension ElementAnimation {
    
    static func defaultAnimation(
        duration: CGFloat = DeclarativeUISettings.Animation.duration,
        delay: CGFloat = 0
    ) -> ElementAnimation {
        return .init(duration: duration, delay: delay)
    }
    
    static func fadeInAnimation(
        duration: CGFloat = 0.1,
        delay: CGFloat = 0
    ) -> ElementAnimation {
        let animation: ElementAnimation = .init(
            duration: duration,
            delay: delay,
            options: .curveLinear,
            animatePreAction: { view in
                view.alpha = 0.0
            },animateAction: { view in
                view.alpha = 1.0
            }
        )
        return animation
    }
    
    static func changeBackgroundColor(
        _ color: UIColor,
        duration: CGFloat = 0.1,
        delay: CGFloat = 0
    ) -> ElementAnimation {
        let animation: ElementAnimation = .init(
            duration: duration,
            delay: delay,
            options: .curveLinear,
            animateAction: { view in
                if view.backgroundColor != nil {
                    view.backgroundColor = color
                } else {
                    view.subviews.forEach { subview in
                        if subview.backgroundColor != nil {
                            subview.backgroundColor = color
                        }
                    }
                }
            }
        )
        return animation
    }
    
}
