//
//  CATransform3D+Extensions.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 10.06.2023.
//  Copyright © 2023 Sergey Pozhidaev. All rights reserved.
//

import UIKit

extension CATransform3D
{
    static func grouped(_ transforms: [CATransform3D]) -> CATransform3D
    {
        var result = CATransform3DIdentity
        for transform in transforms {
            result = CATransform3DConcat(result, transform)
        }
        return result
    }
}
