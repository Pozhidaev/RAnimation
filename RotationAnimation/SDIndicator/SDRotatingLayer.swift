//
//  SDRotatingLayer.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 16.03.2019.
//  Copyright © 2019 Sergey Pozhidaev. All rights reserved.
//

import CoreGraphics
import UIKit

public class SDRotatingLayer: CALayer
{
    //MARK: - Private variables

    private let gradientLayer = CAGradientLayer()
    private let makeTransformFunc: (Double, Int) -> CATransform3D

    //MARK: - Public variables

    public let index: Int

    public var timing: [Double] = []

    public var config: SDIndicatorConfig = .defaultConfig { didSet {
        cornerRadius = config.cornerRadius
        borderWidth = config.borderWidth
        borderColor = config.borderColor.cgColor
        
        gradientLayer.colors = config.colors.map{ $0.cgColor }
        gradientLayer.type = .axial
        
        gradientLayer.startPoint = SDGradientPoint.start.valueFor(config.startGradientAngle)
        gradientLayer.endPoint = SDGradientPoint.end.valueFor(config.startGradientAngle)

        transform = makeTransformFunc(config.startAngle, index)
    } }
    
    public override var bounds: CGRect { didSet {
        gradientLayer.bounds = bounds
        gradientLayer.position = CGPointMake(CGRectGetMidX(bounds),
                                             CGRectGetMidY(bounds))
    } }
    
    //MARK: - Memory

    init(index: Int,
         makeTransformFunc: @escaping (Double, Int) -> CATransform3D)
    {
        self.index = index
        self.makeTransformFunc = makeTransformFunc

        super.init()
        
        addSublayer(gradientLayer)
    }
    
    public override init(layer: Any)
    {
        guard let layer = layer as? SDRotatingLayer else {
            fatalError("RotatingLayer initialize with layer of type \(type(of: layer))")
        }

        self.index = layer.index
        self.timing = layer.timing
        self.makeTransformFunc = layer.makeTransformFunc
        
        super.init(layer: layer)

        self.sublayers = layer.sublayers
        
        config = layer.config
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Public methods
    
    public func startAnimation()
    {
        addPointAnimation(for: .start)
        addPointAnimation(for: .end)
        addTransformAnimation()
    }
    
    public func stopAnimation()
    {
        gradientLayer.removeAllAnimations()
        self.removeAllAnimations()
    }
    
    //MARK: - Private
    
    private func addTransformAnimation()
    {
        let animation = pointAnimation(for: .end)
        animation.keyPath = "transform"
        animation.values = timing.map{ makeTransformFunc($0, index) }
        animation.duration = config.animationDuration
        animation.repeatCount = Float.infinity
        self.add(animation, forKey: animation.keyPath)
    }
    
    private func addPointAnimation(for point: SDGradientPoint)
    {
        let anim = pointAnimation(for: point)
        gradientLayer.add(anim, forKey: point.keyPath)
    }

    private func pointAnimation(for point: SDGradientPoint) -> CAKeyframeAnimation
    {
        let animation = CAKeyframeAnimation.init(keyPath: point.keyPath)
        animation.duration = config.animationDuration
        animation.values = timing.map{ point.valueFor( -($0 + Double(config.startGradientAngle)) ) }
        animation.repeatCount = Float.infinity
        animation.calculationMode = .linear
        return animation
    }
}
