//
//  Layout.swift
//  DeclarativeUI
//
//  Created by Renato Cardial on 9/30/23.
//

import UIKit

public protocol ObservableData {}

open class Layout: UIViewController, SkeletonDisplayable {
    
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


// 1
public protocol SkeletonDisplayable {
    func showSkeleton()
    func hideSkeleton()
}

public extension SkeletonDisplayable where Self: UIViewController {

    // 5
    func showSkeleton() {
        let skeletons = skeletonViews(in: view)
        let backgroundColor = UIColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        let highlightColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0).cgColor

        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = UIScreen.main.bounds.size

        skeletons.forEach {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = UIScreen.main.bounds
            gradientLayer.name = skeletonGradientName

            $0.layer.mask = skeletonLayer
            $0.layer.addSublayer(skeletonLayer)
            $0.layer.addSublayer(gradientLayer)
            $0.clipsToBounds = true
            let widht = UIScreen.main.bounds.width

            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 3
            animation.fromValue = -widht
            animation.toValue = widht
            animation.repeatCount = .infinity
            animation.autoreverses = false
            animation.fillMode = CAMediaTimingFillMode.forwards

            gradientLayer.add(animation, forKey: "gradientLayerShimmerAnimation")
        }
    }

    // 6
    func hideSkeleton() {
        skeletonViews(in: view).forEach {
            $0.layer.sublayers?.removeAll {
                $0.name == skeletonLayerName || $0.name == skeletonGradientName
            }
        }
    }
}

// 2
extension SkeletonDisplayable where Self: UIViewController {

    // 3
    private var skeletonLayerName: String {
        return "skeletonLayerName"
    }

    private var skeletonGradientName: String {
        return "skeletonGradientName"
    }

    // 4
    private func skeletonViews(in view: UIView) -> [UIView] {
        var results = [UIView]()
        for subview in view.subviews as [UIView] {
            switch subview {
            case _ where subview.isKind(of: UILabel.self):
                results += [subview]
            case _ where subview.isKind(of: UIImageView.self):
                results += [subview]
            case _ where subview.isKind(of: UIButton.self):
                results += [subview]
            default: results += skeletonViews(in: subview)
            }

        }
        return results
    }

    
}
