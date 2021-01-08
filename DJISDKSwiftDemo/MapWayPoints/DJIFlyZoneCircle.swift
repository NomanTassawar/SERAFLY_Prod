//
//  DJIFlyZoneCircle.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 02/01/2021.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class DJIFlyZoneCircle: MKCircle {
    var flyZoneCoordinate: CLLocationCoordinate2D?
    var flyZoneRadius: CGFloat = 0.0
    var category: UInt8 = 0
    var flyZoneID = 0
    var name: String?
    var limitHeight: CGFloat = 0.0

}
