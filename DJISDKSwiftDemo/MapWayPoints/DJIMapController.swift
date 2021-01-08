//
//  DJIMapController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 22/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import MapKit
let UPDATETIMESTAMP = 10
class DJIMapController:NSObject , MKMapViewDelegate {
     var editPoints: [AnyHashable]?
    var aircraftCoordinate: CLLocationCoordinate2D?
    weak var mapView: MKMapView?
    var aircraftAnnotation: DJIAircraftAnnotation?
    var mapOverlays: [DJIMapOverlay]?
    var customUnlockOverlays: [DJIMapOverlay]?
    var lastUpdateTime: TimeInterval = 0.0
    var flyZones: [AnyHashable]?
    
    init?(map mapView: MKMapView?) {
        if nil != mapView {
            super.init()
            self.mapView = mapView
            self.mapView?.delegate = self
            flyZones = [AnyHashable]()
            mapOverlays = [DJIMapOverlay]()
            forceUpdateFlyZones()
        }
        return nil
    }
    
    deinit {
        if (aircraftAnnotation != nil) {
            aircraftAnnotation = nil
        }
        if mapView?.delegate != nil {
            mapView?.delegate = nil
        }
        if let mapView = mapView {
            print("Have to nill the MapView")
        }
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
    
    
//    func updateAircraftLocation(_ location: CLLocationCoordinate2D, with mapView: MKMapView?) {
//        if aircraftAnnotation == nil {
//            aircraftAnnotation = DJIAircraftAnnotation(coordinate: location)
//            mapView?.addAnnotation(aircraftAnnotation as! MKAnnotation)
//        }
//
//        aircraftAnnotation?.coordinate = location
//    }
    
    func updateAircraftLocation(_ coordinate: CLLocationCoordinate2D, withHeading heading: CGFloat, with mapView: MKMapView?) {
        if CLLocationCoordinate2DIsValid(coordinate) {

            aircraftCoordinate = coordinate

            if aircraftAnnotation == nil {
                aircraftAnnotation = DJIAircraftAnnotation(coordinate: coordinate /*, heading: heading*/)
                mapView?.addAnnotation(aircraftAnnotation!)
                let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(500), longitudinalMeters: CLLocationDistance(500))
                let adjustedRegion = mapView?.regionThatFits(viewRegion)
                if let adjustedRegion = adjustedRegion {
                    mapView?.setRegion(adjustedRegion, animated: true)
                }
            } else {
                aircraftAnnotation?.coordinate = coordinate
                let annotationView = mapView?.view(for: aircraftAnnotation!) as? DJIAircraftAnnotationView
                annotationView?.updateHeading(Float(heading))
            }
        }
    }
    
    

    func updateAircraftHeading(_ heading: Float) {
        if (aircraftAnnotation != nil) {
            aircraftAnnotation?.updateHeading(heading)
        }
    }
    
    func updateFlyZones() {
        if canUpdateLimitFlyZoneWithCoordinate() {
            updateFlyZonesInSurroundingArea()
        }
    }
    func canUpdateLimitFlyZoneWithCoordinate() -> Bool {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let interval = currentTime - lastUpdateTime

        if Int(interval)  < UPDATETIMESTAMP {
            return false
        }

        lastUpdateTime = Date.timeIntervalSinceReferenceDate
        return true
    }
   
    func forceUpdateFlyZones() {
        updateFlyZonesInSurroundingArea()
    }

    func updateFlyZonesInSurroundingArea() {
        DJISDKManager.flyZoneManager()?.getFlyZonesInSurroundingArea(completion: { (infos, error) in
            if nil == error && nil != infos {
                self.updateFlyZoneOverlay(withInfos: infos)
            } else {
                if let description = error?.localizedDescription {
                    print("Get fly zone failed: \(description)")
                }
                if self.mapOverlays!.count > 0 {
                 self.removeMapOverlays(self.mapOverlays)
                }
                if self.flyZones!.count > 0 {
                    self.flyZones?.removeAll()
                }
            }
        })
    }
    
    
    
    func updateFlyZoneOverlay(withInfos flyZoneInfos: [DJIFlyZoneInformation]?) {
        if flyZoneInfos != nil && (flyZoneInfos?.count ?? 0) > 0 {
            let block = {
                for i in 0..<(flyZoneInfos?.count ?? 0) {
                    let flyZoneLimitInfo = flyZoneInfos?[i]
                    var aOverlay: DJILimitSpaceOverlay? = nil
                    for aaMapOverlay  in self.mapOverlays! {
                        var aMapOverlay = aaMapOverlay as! DJILimitSpaceOverlay
                        if aMapOverlay.limitSpaceInfo?.flyZoneID == flyZoneLimitInfo?.flyZoneID && (aMapOverlay.limitSpaceInfo?.subFlyZones?.count == flyZoneLimitInfo?.subFlyZones?.count) {
                            aOverlay = aMapOverlay
                            break
                        }
                    }
                }

            }
        }
    }
    
    func removeMapOverlays(_ objects: [AnyHashable]?) {
        if (objects?.count ?? 0) <= 0 {
            return
        }
        var overlays: [AnyHashable] = []
        for aMapOverlay in objects ?? [] {
            guard let aMapOverlay = aMapOverlay as? DJIMapOverlay else {
                continue
            }
            for aOverlay in aMapOverlay.subOverlays! {
                overlays.append(aOverlay! as! AnyHashable)
            }
        }
        if Thread.isMainThread {
            mapOverlays = mapOverlays!.filter({ !objects!.contains($0) })
            if let overlays = overlays as? [MKOverlay] {
                mapView?.removeOverlays(overlays)
            }
        } else {
            DispatchQueue.main.sync(execute: { [self] in
                mapOverlays = mapOverlays!.filter({ !objects!.contains($0) })
                if let overlays = overlays as? [MKOverlay] {
                    mapView?.removeOverlays(overlays)
                }
            })
        }
    }
    
}
