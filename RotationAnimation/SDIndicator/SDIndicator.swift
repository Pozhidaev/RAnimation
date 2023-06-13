//
//  SDIndicator.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 31.05.2023.
//  Copyright © 2023 Sergey Pozhidaev. All rights reserved.
//

import CoreGraphics
import UIKit

public class SDIndicator: UIView, CAAnimationDelegate
{
    //MARK: - Constants

    private let maxAngle = Double.pi * 2.0
    
    //MARK: - Private variables

    private let transformLayer = CATransformLayer()
    private var animate = false
    private var layersSpace: CGFloat { get {
        return (bounds.height - bounds.width) / CGFloat(config.layersCount)
    } }

    //MARK: - Public variables
    
    public var config: SDIndicatorConfig = .defaultConfig { didSet {
        transformLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        (0..<config.layersCount).forEach{_ in addLayer() }
        
        updateLayersFrames()
        updateLayers()
    } }
    
    //MARK: - Lifecycle
    
    public override func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        
        layer.addSublayer(transformLayer)
        
        (0..<config.layersCount).forEach{_ in addLayer() }
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        transformLayer.bounds = bounds
        
        updateLayersFrames()
        updateLayers()
    }
    
    // MARK: - Public methods
    
    public func startAnimation()
    {
        animate = true

        guard let sublayers = transformLayer.sublayers else { return }
        for case let sublayer as SDRotatingLayer in sublayers {
            sublayer.startAnimation()
        }
    }
    
    public func stopAnimation()
    {
        animate = false
        
        guard let sublayers = transformLayer.sublayers else { return }
        for case let sublayer as SDRotatingLayer in sublayers {
            sublayer.stopAnimation()
        }
    }
    
    //MARK: - Private

    private func addLayer()
    {
        let index = transformLayer.sublayers?.count ?? .zero
        
        let rotationLayer = SDRotatingLayer(
            index: index,
            makeTransformFunc: layerTransform
        )
        rotationLayer.masksToBounds = true

        transformLayer.insertSublayer(rotationLayer, below: transformLayer.sublayers?.last)
        
        updateLayersFrames()
        updateLayers()
        
        if animate {
            rotationLayer.startAnimation()
        }
    }

    private func removeLayer()
    {
        transformLayer.sublayers?.last?.removeFromSuperlayer()
        
        updateLayers()
    }
    
    private func updateLayersFrames()
    {
        transformLayer.frame = bounds

        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let width = bounds.width / sqrt(2)
        let size = CGSize(width: width, height: width)
        
        let halfHeightOfAllLayers = ( Double(config.layersCount) * layersSpace ) / 2.0
        let positionY = CGRectGetMidY(bounds) - halfHeightOfAllLayers
        let positionX = CGRectGetMidX(bounds)

        transformLayer.sublayers?.enumerated().forEach({ index, layer in
            layer.bounds = CGRect(origin: .zero, size: size)
            layer.position = CGPoint(x: positionX, y: positionY)
        })
    }
    
    private func updateLayers()
    {
        guard let sublayers = transformLayer.sublayers else { return }
        for case let sublayer as SDRotatingLayer in sublayers {
            sublayer.timing = timingsForLayers(count: config.layersCount, index: sublayer.index)
            sublayer.config = config
        }
    }
    
    private func layerTransform(_ angle: Double, index: Int) -> CATransform3D
    {
        let rotationX = CATransform3DMakeRotation(CGFloat(config.horizontalAngle), 1, 0, 0)
        let rotationZ = CATransform3DMakeRotation(CGFloat(angle + config.startAngle), 0, 0, 1)

        let dx: CGFloat = 0.0
        let dy: CGFloat = CGFloat(index) * layersSpace
        let dz: CGFloat = 0.0//CGFloat(index) * config.layerSpace
        let translate = CATransform3DMakeTranslation(dx, dy, dz)

        let b = CATransform3D.grouped([translate, rotationZ, rotationX])
        let c = CATransform3D.grouped([rotationZ, rotationX, translate])

        return c
    }

    private func timingsForLayers(count: Int, index: Int) -> [Double]
    {
        let timingFunction = [0.0, 0.05, 0.1, 0.2, 0.4, 0.8, 0.9, 0.97, 0.99, 1.0]
        let timingFunction1 = [0.0, 0.4, 0.7, 0.9, 1.0]
        let timingFunction2 = [0.0, 0.05, 0.1, 0.2, 0.4, 0.8, 0.9, 0.97, 0.99, 1.0]
        let timingFunction3 = [0.0, 0.4, 0.7, 0.9, 1.0]
        let timingFunctions = [timingFunction, timingFunction1, timingFunction2, timingFunction3]
        
        let k = 1.0 / Double(count)
        let b = 0.1 / Double(count)

        let y0 = 0.0 - b * Double(count - index)
        let y1 = 1.0 - k * Double(index)
        let y2 = 1.0 + b * Double(index)
        let y3 = 0.0 + k * Double(count - index)
        
        let timing: (Int) -> [Double] = { ind in
            //return (0...10).map{ Double($0) / 10 } // test data
            return timingFunctions[ind - 1]
        }
        
        var phases = [[Double]]()
        phases.append( timing(1).map{ y0 + $0 * (y1 - y0)} )
        phases.append( timing(2).map{ y1 + $0 * (y2 - y1)} )
        phases.append( timing(3).map{ y2 + $0 * (y3 - y2)} )
        phases.append( timing(4).map{ y3 + $0 * (y0 - y3)} )
        
        let values = phases.flatMap{ $0 }.map{ self.maxAngle * $0 }
        
        return values
    }
    
}
