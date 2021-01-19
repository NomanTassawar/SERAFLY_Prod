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

class DJIGridAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var heading: CGFloat = 0.0
    
    weak var annotationView: DJIGridAnnotationView?

  init(coordinate: CLLocationCoordinate2D/*, heading: CGFloat*/) {
     
      self.coordinate = coordinate
//      self.heading = heading
     super.init()
  }

    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        coordinate = newCoordinate
    }

}

class DummyAircraftAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var heading: CGFloat = 9.0
    
    weak var annotationView: DummyAircraftAnnotationView?

  init(coordinate: CLLocationCoordinate2D/*, heading: CGFloat*/) {
     
      self.coordinate = coordinate
//      self.heading = heading
   
     super.init()
  }

    func setCoordinate(_ newCoordinate: CLLocationCoordinate2D) {
        coordinate = newCoordinate
    }
    func updateHeading(_ heading: Double) {
        if (annotationView != nil) {
            annotationView!.updateHeading(heading)
        }
    }
    func animateAircraft(updatedCordinate:CLLocationCoordinate2D , head:Double , completionhandler: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            self.updateHeading(head)
            UIView.animate(withDuration: 2.0, animations: {
                self.coordinate = updatedCordinate
            }) { (success) in
                completionhandler(success)
            }
        }
        
    }
}
