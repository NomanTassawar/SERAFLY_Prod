//
//  PolyLineMapController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 27/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import MapKit

class PolyLineMapController: UIViewController {

    var points = [CLLocationCoordinate2D]() {
        didSet {
            print(points)
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       // mapView.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: Map Touch Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mapView.removeOverlays(mapView.overlays) //Reset shapes
        if let touch = touches.first {
            let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
            points.append(coordinate)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let coordinate = mapView.convert(touch.location(in: mapView), toCoordinateFrom: mapView)
            points.append(coordinate)
            let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.addOverlay(polyline) //Add lines
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon) //Add polygon areas
        points = [] //Reset points
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PolyLineMapController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .lightText
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}
