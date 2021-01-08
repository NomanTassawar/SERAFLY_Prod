//
//  RootMapViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Macbook on 22/12/2020.
//  Copyright © 2020 DJI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DJISDK

class RootMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate, DJISDKManagerDelegate, DJIFlightControllerDelegate{
    func appRegisteredWithError(_ error: Error?) {
        if let error = error {
            let registerResult = "Registration Error:\(error.localizedDescription)"
           // ShowMessage("Registration Result", registerResult, nil, "OK")
        } else {
            DJISDKManager.startConnectionToProduct()
        }
    }
    
    func didUpdateDatabaseDownloadProgress(_ progress: Progress) {
        print("idUpdateDatabaseDownloadProgress")
    }
    func productConnected(_ product: DJIBaseProduct?) {
        if product != nil {
            let flightController = DemoUtility.fetchFlightController()
            if let flightController = flightController {
                flightController.delegate = self
            }
        } else {
           // ShowMessage("Product disconnected", nil, nil, "OK")
        }
    }
    
    // Alert Action Controller
    @IBOutlet private var modeLabel: UILabel!
    @IBOutlet private var gpsLabel: UILabel!
    @IBOutlet private var hsLabel: UILabel!
    @IBOutlet private var vsLabel: UILabel!
    @IBOutlet private var altitudeLabel: UILabel!
    private var droneLocation: CLLocationCoordinate2D?
    // End
    
    // Declaring these methods for Polygons and Polylines.
    var points = [CLLocationCoordinate2D]()
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var mapController: DJIMapController?
    var tapGesture: UITapGestureRecognizer?
    
    // Use for current locatino detection
    var locationManager: CLLocationManager?
    var userLocation: CLLocationCoordinate2D?
    
    var isEditingPoints = false
    
    func initUI() {
        modeLabel.text = "N/A"
        gpsLabel.text = "0"
        vsLabel.text = "0.0 M/S"
        hsLabel.text = "0.0 M/S"
        altitudeLabel.text = "0 M"
    }
    func initData() {
        userLocation = kCLLocationCoordinate2DInvalid
        droneLocation = kCLLocationCoordinate2DInvalid

        mapController = DJIMapController(map: mapView)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWaypoints(_:)))
        mapView?.addGestureRecognizer(tapGesture!)

    }
    func registerApp() {
        //Please enter your App key in the info.plist file to register the app.
        DJISDKManager.registerApp(with: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         userLocation = kCLLocationCoordinate2DInvalid
        mapController = DJIMapController(map: mapView)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWaypoints(_:)))
        mapView.addGestureRecognizer(tapGesture!)
       
//        registerApp()
//        initUI()
//        initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         startUpdateLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager?.stopUpdatingLocation()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK: MAP TOUCH METHODS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mapView.removeOverlays(mapView.overlays)
       // mapView.isUserInteractionEnabled = false
        if let touch = touches.first {
           let coordinate = mapView.convert(touch.location(in: mapView),      toCoordinateFrom: mapView)
           points.append(coordinate)
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
        let coordinate = mapView.convert(touch.location(in: mapView),       toCoordinateFrom: mapView)
         points.append(coordinate)
         let polyline = MKPolyline(coordinates: points, count: points.count)
            mapView.addOverlay(polyline)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        mapView.addOverlay(polygon)
        points = [] // Reset points
       // mapView.isUserInteractionEnabled = true
    }
    // MARK: CLLocation Methods
    func startUpdateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.distanceFilter = CLLocationDistance(0.1)
                if (locationManager?.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)))! {
                    locationManager?.requestAlwaysAuthorization()
                }
                locationManager?.startUpdatingLocation()
            }
        } else {
            let alert = UIAlertController(title: "Location Service is not available", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                print("Printed text")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Custom Methods
    @objc func addWaypoints(_ tapGesture: UITapGestureRecognizer?) {
        guard let point = tapGesture?.location(in: mapView) else { return  }

        if tapGesture?.state == .ended {

            if isEditingPoints {
                mapController!.add(point, with: mapView)
            }
        }
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        if isEditingPoints {
            mapController!.cleanAllPoints(with: mapView)
               editBtn.setTitle("Edit", for: .normal)
            mapView.isUserInteractionEnabled = false
           } else {
               editBtn.setTitle("Reset", for: .normal)
            mapView.isUserInteractionEnabled = true
           }

           isEditingPoints = !isEditingPoints
        
    }
    
    @IBAction func focusMapAction(_ sender: UIButton) {
        if CLLocationCoordinate2DIsValid(userLocation!) {
            var region = MKCoordinateRegion()
            region.center = userLocation!
          //  region.center = droneLocation!
            region.span.latitudeDelta = 0.001
            region.span.longitudeDelta = 0.001
            
            let annotation = DJIAircraftAnnotation(coordinate: userLocation!)
            mapView.addAnnotation(annotation)

            mapView?.setRegion(region, animated: true)
            mapView.showsUserLocation = true
             
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as? CLLocation
        if let coordinate = location?.coordinate {
            userLocation = coordinate
        }
    }
    
    // MARK: MKMapViewDelegate Method

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Aircraft_Annotation")
            //pinView.pinTintColor = .purple
            pinView.image = UIImage(named:"aircraft.png")
            pinView.canShowCallout = true
            return pinView
        } else if annotation is DJIAircraftAnnotation {
            let annoView = DJIAircraftAnnotationView(annotation: annotation, reuseIdentifier: "Aircraft_Annotation")
            (annotation as? DJIAircraftAnnotation)?.annotationView = annoView
            return annoView
        }

        return nil
    }
    
    
    
    
    // Apply this Method for Polygons and PolyLines on Map.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .cyan
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
