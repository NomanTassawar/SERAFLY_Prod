//
//  DJIAircraftAnnotationView.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 23/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import MapKit

class DJIAircraftAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isEnabled = false
        isDraggable = false
        image = UIImage(named: "aircraft.png")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateHeading(_ heading: Float) {
        transform = CGAffineTransform.identity
        transform = CGAffineTransform(rotationAngle: CGFloat(heading))
    }

}
