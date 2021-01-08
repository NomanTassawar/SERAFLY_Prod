//
//  DJIFlyZoneCircleView.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 02/01/2021.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit
import DJISDK
let AuthorizationColor = UIColor.yellow
let RestrictedColor = UIColor.red
let WarningColor = UIColor.green
let EnhancedWarningColor = UIColor.green

class DJIFlyZoneCircleView: MKCircleRenderer {
init(circle: DJIFlyZoneCircle?) {
    super.init(circle: circle!)
    fillColor = UIColor.red.withAlphaComponent(0.2)
    strokeColor = UIColor.red.withAlphaComponent(0.9)

    if circle?.category == DJIFlyZoneCategory.authorization.rawValue {

        self.fillColor = AuthorizationColor.withAlphaComponent(0.1)
        strokeColor = AuthorizationColor.withAlphaComponent(1.0)
    } else if circle?.category == DJIFlyZoneCategory.restricted.rawValue {

        fillColor = RestrictedColor.withAlphaComponent(0.1)
        strokeColor = RestrictedColor.withAlphaComponent(1.0)
    } else if circle?.category == DJIFlyZoneCategory.warning.rawValue{
        

        fillColor = WarningColor.withAlphaComponent(0.1)
        strokeColor = WarningColor.withAlphaComponent(1.0)
    } else if circle?.category == DJIFlyZoneCategory.enhancedWarning.rawValue {

        fillColor = EnhancedWarningColor.withAlphaComponent(0.1)
        strokeColor = EnhancedWarningColor.withAlphaComponent(1.0)
    }
    
    
    lineWidth = 3.0
}
}
