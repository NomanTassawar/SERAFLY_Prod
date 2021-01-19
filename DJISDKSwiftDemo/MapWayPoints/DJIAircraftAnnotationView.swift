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

class DJIGridAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isEnabled = true
        isDraggable = true
        image = UIImage(named: "plus2.png")
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


class DummyAircraftAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isEnabled = true
        isDraggable = true
        image = UIImage(named: "aircraft.png")
        //updateHeading(9.0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHeading(_ heading: Double) {
        transform = CGAffineTransform.identity
        transform = CGAffineTransform(rotationAngle: CGFloat(heading))
    }
    

}
