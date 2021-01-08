//
//  DJIFlyZoneColorProvider.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 02/01/2021.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
//0x979797
let DJI_FS_HEIGHT_LIMIT_GRAY_01 = UIColor(r: 151, g: 151, b: 151, a: 0.1)
let DJI_FS_HEIGHT_LIMIT_GRAY_1 = UIColor(r: 151, g: 151, b: 151, a: 1)
//0xDE4329
let DJI_FS_LIMIT_RED_01 = UIColor(r: 222, g: 67, b: 41, a: 0.1)
let DJI_FS_LIMIT_RED_1 = UIColor(r: 222, g: 67, b: 41, a: 1)
//0x1088F2
let DJI_FS_AUTH_BLUE_01 = UIColor(r: 16, g: 136, b: 242, a: 0.1)
let DJI_FS_AUTH_BLUE_1 = UIColor(r: 16, g: 136, b: 242, a: 1)
//0xFFCC00
let DJI_FS_WARNING_YELLOW_01 = UIColor(r: 255, g: 204, b: 0, a: 0.1)
let DJI_FS_WARNING_YELLOW_1 = UIColor(r: 255, g: 204, b: 0, a: 1)
//0xEE8815
let DJI_FS_SPECIAL_WARNING_ORANGE_01 = UIColor(r: 238, g: 136, b: 21, a: 0.1)
let DJI_FS_SPECIAL_WARNING_ORANGE_1 = UIColor(r: 238, g: 136, b: 21, a: 1)

//  Converted to Swift 5.2 by Swiftify v5.2.23024 - https://swiftify.com/
class DJIFlyZoneColorProvider {
    class func getFlyZoneOverlayColor(withCategory category: UInt8, isHeightLimit: Bool, isFill: Bool) -> UIColor? {

        if isHeightLimit {
            return isFill ? DJI_FS_HEIGHT_LIMIT_GRAY_01 : DJI_FS_HEIGHT_LIMIT_GRAY_1
        }

        if category == DJIFlyZoneCategory.authorization.rawValue {
            return isFill ? DJI_FS_AUTH_BLUE_01 : DJI_FS_AUTH_BLUE_1
        } else if category == DJIFlyZoneCategory.restricted.rawValue {
            return isFill ? DJI_FS_LIMIT_RED_01 : DJI_FS_LIMIT_RED_1
        } else if category == DJIFlyZoneCategory.warning.rawValue {
            return isFill ? DJI_FS_WARNING_YELLOW_01 : DJI_FS_WARNING_YELLOW_1
        } else if category == DJIFlyZoneCategory.enhancedWarning.rawValue {
            return isFill ? DJI_FS_SPECIAL_WARNING_ORANGE_01 : DJI_FS_SPECIAL_WARNING_ORANGE_1
        }
        return UIColor(r: 0, g: 0, b: 0, a: 0)
    }
}
