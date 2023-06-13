//
//  SDAnimatorConfig.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 19.03.2019.
//  Copyright © 2019 Sergey Pozhidaev. All rights reserved.
//

import UIKit

public struct SDIndicatorConfig
{
    public var cornerRadius: CGFloat
    public var borderWidth: CGFloat
    public var borderColor: UIColor
    
    public var colors: [UIColor]
    
    public var layersCount: Int
    
    public var startGradientAngle: Double
    public var startAngle: Double
    public var horizontalAngle: Double
    
    public var animationDuration: Double
    
    public static let defaultConfig = SDIndicatorConfig(
        cornerRadius: 24.0,
        borderWidth: 1.0,
        borderColor: UIColor.clear,
        colors: [UIColor.orange, UIColor.black],
        layersCount: 50,
        startGradientAngle: 1.5,
        startAngle: 1.5,
        horizontalAngle: 1.0,
        animationDuration: 2.7
    )
}
