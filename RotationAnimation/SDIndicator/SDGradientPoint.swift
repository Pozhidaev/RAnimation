//
//  SDGradientPoint.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 19.03.2019.
//  Copyright © 2019 Sergey Pozhidaev. All rights reserved.
//

import Foundation

enum SDGradientPoint
{
    case start
    case end

    var keyPath: String {
        switch self {
        case .start: return "startPoint"
        case .end: return "endPoint"
        }
    }
    
    var endPointOffset: Double {
        switch self {
        case .start: return .zero
        case .end: return Double.pi
        }
    }
    
    func valueFor(_ angle: Double) -> CGPoint
    {
        let radius = sqrt(2.0)
        let convertedAngle = angle + (Double.pi / 2.0) + self.endPointOffset
        let x = ((cos(convertedAngle) + 1) / 2.0) * radius
        let y = ((sin(convertedAngle) + 1) / 2.0) * radius
        let point = CGPoint(x: min(x, 1), y: min(y, 1))
        return point
    }
}
