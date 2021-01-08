//
//  DJILimitSpaceOverlay.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 02/01/2021.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

let kDJILimitFlightSpaceBufferHeight = 5
class DJILimitSpaceOverlay: DJIMapOverlay {
    var limitSpaceInfo: DJIFlyZoneInformation?
    init?(limitSpace limitSpaceInfo: DJIFlyZoneInformation?) {
        super.init()
        self.limitSpaceInfo = limitSpaceInfo
        createOverlays()
    }
    
    func overlys(forSubFlyZoneSpace aSpace: DJISubFlyZoneInformation?) -> [MKOverlay?]? {
        let isHeightLimit = (aSpace?.maximumFlightHeight ?? 0) > 0 && aSpace!.maximumFlightHeight < Int.max
        if aSpace?.shape == DJISubFlyZoneShape.cylinder {
            let coordinateInMap = aSpace?.center
            var circle: DJICircle? = nil
            if let coordinateInMap = coordinateInMap {
                circle = DJICircle(
                    center: coordinateInMap,
                    radius: aSpace?.radius ?? 0)
            }
            circle?.lineWidth = strokLineWidth(withHeight: aSpace!.maximumFlightHeight)
            circle?.fillColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: limitSpaceInfo!.category.rawValue, isHeightLimit: isHeightLimit, isFill: true)
            circle?.strokeColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: limitSpaceInfo!.category.rawValue, isHeightLimit: isHeightLimit, isFill: false)
            return [circle]
        } else if aSpace?.shape == DJISubFlyZoneShape.polygon {
            if (aSpace?.vertices.count)! <= 0 {
                return []
            }

           // let coordinates = malloc(MemoryLayout<CLLocationCoordinate2D>.size * (aSpace?.vertices.count)!) as? CLLocationCoordinate2D
           // var coordinates: [UnsafeMutablePointer<CLLocationCoordinate2D>?] = Array(repeating: nil, count: (aSpace?.vertices.count)!)
            var coordinates = [CLLocationCoordinate2D](repeating: CLLocationCoordinate2D(), count: (aSpace?.vertices.count)!)
            
            var i = 0
            for i in 0..<(aSpace?.vertices.count)! {
                let aPointValue = aSpace!.vertices[i] as? NSValue
                let coordinate = aPointValue?.mkCoordinateValue
                let coordinateInMap = coordinate
                coordinates[i] = coordinateInMap!
            }
            let polygon = DJIMapPolygon(coordinates: coordinates, count: (aSpace?.vertices.count)!)
            polygon.lineWidth = strokLineWidth(withHeight: aSpace!.maximumFlightHeight)
            polygon.strokeColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: limitSpaceInfo!.category.rawValue, isHeightLimit: isHeightLimit, isFill: false)
            polygon.fillColor = DJIFlyZoneColorProvider.getFlyZoneOverlayColor(withCategory: limitSpaceInfo!.category.rawValue, isHeightLimit: isHeightLimit, isFill: true)
            //free(coordinates)
            return [polygon]
        }
        return nil
    }
    
    func overlys(forFlyZoneSpace aSpace: DJIFlyZoneInformation?) -> [MKOverlay?]? {
        if aSpace == nil {
            return []
        }
        if (aSpace?.subFlyZones?.count ?? 0) <= 0 {
            let coordinateInMap = aSpace?.center
            let radius = aSpace?.radius ?? 0.0

            var circle: DJIFlyZoneCircle? = nil
            if let coordinateInMap = coordinateInMap {
                circle = DJIFlyZoneCircle(center: coordinateInMap, radius: CLLocationDistance(radius))
            }
            circle?.category = (aSpace?.category)!.rawValue
            circle?.flyZoneID = Int(aSpace!.flyZoneID)
            circle?.name = aSpace?.name
            circle?.limitHeight = 0
            return [circle]
        } else {
            var results = [MKOverlay?]()
            if let subFlyZones = aSpace?.subFlyZones {
                for aSubSpace in subFlyZones {
                    guard let aSubSpace = aSubSpace as? DJISubFlyZoneInformation else {
                        continue
                    }
                    let subOverlays = overlys(forSubFlyZoneSpace: aSubSpace)
                    results.append(contentsOf: subOverlays!)
                }
            }

            return results as? [MKOverlay?]
        }
        return []
    }
    
    func createOverlays() {
        subOverlays = [MKOverlay?]()
        let overlays = overlys(forFlyZoneSpace: limitSpaceInfo)
        subOverlays?.append(contentsOf: overlays!)
    }

    func strokLineWidth(withHeight height: Int) -> CGFloat {
        if height <= 30 + kDJILimitFlightSpaceBufferHeight {
            return 0
        }
        return 1.0
    }

}
