//
//  Configs.swift
//  RotationAnimation
//
//  Created by Sergey Pozhidaev on 10.06.2023.
//  Copyright © 2023 Sergey Pozhidaev. All rights reserved.
//

import UIKit

final class Configs
{
    static var configurations: [(String, SDIndicatorConfig)]
    {
        [("Orange 1", SDIndicatorConfig(
            cornerRadius: 32.0,
            borderWidth: 1.0,
            borderColor: UIColor.black,
            colors: [UIColor.orange, UIColor.black],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 10.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
         ("Orange 2", SDIndicatorConfig(
            cornerRadius: 32.0,
            borderWidth: 0.0,
            borderColor: UIColor.clear,
            colors: [UIColor.orange, UIColor.black],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 10.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
         ("Magenta Cyan", SDIndicatorConfig(
            cornerRadius: 24.0,
            borderWidth: 0.0,
            borderColor: UIColor.clear,
            colors: [UIColor.magenta, UIColor.cyan],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 1.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
         ("Green", SDIndicatorConfig(
            cornerRadius: 32.0,
            borderWidth: 1.0,
            borderColor: UIColor.black,
            colors: [UIColor.green, UIColor.green],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 10.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
         ("Magenta", SDIndicatorConfig(
            cornerRadius: 32.0,
            borderWidth: 1.0,
            borderColor: UIColor.black,
            colors: [UIColor.clear, UIColor.clear, UIColor.magenta, UIColor.clear, UIColor.clear],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 10.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
         ("Clear", SDIndicatorConfig(
            cornerRadius: 16.0,
            borderWidth: 2.0,
            borderColor: UIColor.black,
            colors: [UIColor.clear],
            layersCount: 40,
            startGradientAngle: 1.5,
            startAngle: 10.0,
            horizontalAngle: 1.2,
            animationDuration: 2.7
                                    )),
        ]
    }
}
