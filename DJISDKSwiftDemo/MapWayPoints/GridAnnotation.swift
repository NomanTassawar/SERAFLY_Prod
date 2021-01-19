//
//  GridAnnotation.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 10/01/2021.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class GridAnnotation: MKPointAnnotation {
    var identifier: Int?
    init(id:Int) {
        identifier = id
    }
}
