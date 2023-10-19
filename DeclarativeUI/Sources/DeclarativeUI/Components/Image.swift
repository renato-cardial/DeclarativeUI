//
//  Image.swift
//  
//
//  Created by Renato Cardial on 10/13/23.
//

import UIKit

public class Image: ElementView  {
    
    public override var elementView: UIView { return imageView }
    lazy var imageView: UIImageView = FactoryView.makeImageView()
    
    public var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    /// Initialize the Image object
    /// Parameter image: Text will be presented in this element
    public init(_ image: UIImage?, id: String = UUID().uuidString) {
        super.init(identifier: id)
        self.imageView.image = image
    }
    
    /// Initialize the Image object
    /// Parameter image: Text will be presented in this element
    public init(_ imageNamed: String, id: String = UUID().uuidString) {
        super.init(identifier: id)
        self.imageView.image = .init(named: imageNamed)
    }
    
}

// MARK: - Public Methods
public extension Image {
    
    @discardableResult
    /// Define the contentMode of image
    /// - Parameter contentMode:UIView.ContentMode
    /// - Returns: Self
    func aspectRatio(contentMode: UIView.ContentMode) -> Self {
        imageView.contentMode = contentMode
        return self
    }
    
    @discardableResult
    /// Define cliptsToBound equal true
    func clipped() -> Self {
        imageView.clipsToBounds = true
        return self
    }
    
    @discardableResult
    func clipShape(_ shaped: ElementShape) -> Self {
        //afterEmbeded.append { [self] in
            imageView.contentMode = .scaleAspectFill
            imageView.layer.mask = shaped.getShapeLayer(frame: imageView.frame)
            imageView.clipsToBounds = true
        //}
        return self
    }
}


extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180
    }
}

public protocol ElementShape {
    var shapeLayer: CAShapeLayer { get set }
    func getShapeLayer(frame: CGRect) -> CAShapeLayer
}

public class Circle: ElementView, ElementShape {
    
    public var shapeLayer: CAShapeLayer = .init()
    
    private lazy var view: UIView = FactoryView.makeView()
    public override var elementView: UIView { return view }
    
    public func getShapeLayer(frame: CGRect) -> CAShapeLayer {
        let path = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2,
            y: frame.size.height / 2),
            radius: frame.size.width / 2.5,
            startAngle: CGFloat(0).toRadians(),
            endAngle: CGFloat(360).toRadians(),
            clockwise: false
        )
        
        // No change
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }
    
    public init(id: String = UUID().uuidString) {
        super.init(identifier: id)
        afterEmbeded.append { [self] in
            shapeLayer = self.getShapeLayer(frame: view.frame)
            view.layer.mask = shapeLayer
            view.clipsToBounds = true
        }
    }
    
}
