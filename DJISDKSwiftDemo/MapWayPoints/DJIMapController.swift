//
//  DJIMapController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 22/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import MapKit
class DJIMapController:NSObject {
     var editPoints: [AnyHashable]?
    var aircraftAnnotation: DJIAircraftAnnotation?
    override init() {
        super.init()
            editPoints = [AnyHashable]()
    }

    func add(_ point: CGPoint, with mapView: MKMapView?) {
        let coordinate = mapView?.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0)
        self.editPoints?.append(location)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapView?.addAnnotation(annotation)
    }

    func cleanAllPoints(with mapView: MKMapView?) {
        self.editPoints?.removeAll()
        var annos: [MKAnnotation]? = nil
        if let annotations = mapView?.annotations {
            annos = annotations
        }
        for i in 0..<(annos?.count ?? 0) {
            weak var ann = annos?[i]
            if let ann = ann {
                mapView?.removeAnnotation(ann)
            }
        }
    }

    func wayPoints() -> [AnyHashable]? {
        return editPoints
    }
    
    
    func updateAircraftLocation(_ location: CLLocationCoordinate2D, with mapView: MKMapView?) {
        if aircraftAnnotation == nil {
            aircraftAnnotation = DJIAircraftAnnotation(coordiante: location)
            mapView?.addAnnotation(aircraftAnnotation as! MKAnnotation)
        }

        aircraftAnnotation?.coordinate = location
    }

    func updateAircraftHeading(_ heading: Float) {
        if (aircraftAnnotation != nil) {
            aircraftAnnotation?.updateHeading(heading)
        }
    }
}
