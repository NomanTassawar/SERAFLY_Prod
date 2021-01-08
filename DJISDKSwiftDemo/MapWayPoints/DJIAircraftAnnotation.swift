//
//  DJIAircraftAnnotation.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 23/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import MapKit

class DJIAircraftAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var heading: CGFloat = 0.0
    
    weak var annotationView: DJIAircraftAnnotationView?

  init(coordinate: CLLocationCoordinate2D/*, heading: CGFloat*/) {
     
      self.coordinate = coordinate
//      self.heading = heading
     super.init()
  }

    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        coordinate = newCoordinate
    }

    func updateHeading(_ heading: Float) {
        if (annotationView != nil) {
            annotationView!.updateHeading(heading)
        }
    }
}
