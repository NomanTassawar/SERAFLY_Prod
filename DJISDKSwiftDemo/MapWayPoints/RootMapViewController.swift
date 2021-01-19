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
    var annotationsArray = [MKPointAnnotation]()
    var gridPoints = [CLLocationCoordinate2D]()
    var fourPoints = [CLLocationCoordinate2D]()
    var dummySimulatorAnnotation:DummyAircraftAnnotation?
    var dummySimulatorFlyPath = [CLLocationCoordinate2D]()
    var gridAnnotationCount = 0
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

        mapController = DJIMapController()
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
        mapController = DJIMapController()
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
//        mapView.removeOverlays(mapView.overlays)
//       // mapView.isUserInteractionEnabled = false
//        if let touch = touches.first {
//           let coordinate = mapView.convert(touch.location(in: mapView),      toCoordinateFrom: mapView)
//           points.append(coordinate)
//
//        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//        let coordinate = mapView.convert(touch.location(in: mapView),       toCoordinateFrom: mapView)
//         points.append(coordinate)
//         let polyline = MKPolyline(coordinates: points, count: points.count)
//            mapView.addOverlay(polyline)
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let polygon = MKPolygon(coordinates: &points, count: points.count)
//        mapView.addOverlay(polygon)
//        points = [] // Reset points
//       // mapView.isUserInteractionEnabled = true
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
                gridAnnotationCount = gridAnnotationCount + 1
                let anotPin = mapController!.add(point, with: mapView, ident: gridAnnotationCount)
                annotationsArray.append(anotPin)
                gridPoints.append(anotPin.coordinate)
            }
        }
    }
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        if isEditingPoints {
            mapController!.cleanAllPoints(with: mapView)
//               editBtn.setTitle("Edit", for: .normal)
//            mapView.isUserInteractionEnabled = false
            
            
           } else {
               editBtn.setTitle("Reset", for: .normal)
//            mapView.isUserInteractionEnabled = true
             mapView.removeOverlays(mapView.overlays)
            gridPoints = [CLLocationCoordinate2D]()
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
            
            dummySimulatorAnnotation = DummyAircraftAnnotation(coordinate: userLocation!)
            mapView.addAnnotation(dummySimulatorAnnotation!)

            mapView?.setRegion(region, animated: true)
            mapView.showsUserLocation = true
             
        }
        
    }
    
    @IBAction func showGidBtnClicked(_ sender: UIButton) {
        drawGrid()
    }
    
    @IBAction func fillGridBtnClicked(_ sender: UIButton) {
        fillGridPath(firstPoint: fourPoints[0], secondPoint: fourPoints[1], thirdPoint: fourPoints[2], fourthPoint: fourPoints[3])
        
    }
    
    @IBAction func testFlightBtnClicked(_ sender: UIButton) {
        var heads = 0.0
        var previousLoc = userLocation
        var newLocation = dummySimulatorFlyPath[0]
         let animateSimulatorGroup = DispatchGroup()
        animateSimulatorGroup.enter()
        let semaphore = DispatchSemaphore(value: 0)
        let flyQueue = DispatchQueue(label: "flyQueue", qos: .default)
        flyQueue.async {
            for point1 in self.dummySimulatorFlyPath{
                newLocation = point1
                heads = self.getAngleBetweenTwoPoints1(pt1: previousLoc!, pt2: newLocation)
                self.dummySimulatorAnnotation?.animateAircraft(updatedCordinate: point1, head: heads, completionhandler: { (success) in
                    semaphore.signal()
                })
                semaphore.wait()
                previousLoc = point1
            }
            animateSimulatorGroup.leave()
        
        }
    }
    
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getAngleBetweenTwoPoints1(pt1 : CLLocationCoordinate2D, pt2 : CLLocationCoordinate2D) -> Double {
        var point1 = CLLocation(latitude: pt1.latitude, longitude: pt1.longitude)
        var point2 = CLLocation(latitude: pt2.latitude, longitude: pt2.longitude)

        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return fmod(radiansToDegrees(radians: radiansBearing), 360.0) + 90.0
    }
    
    func drawGrid(){
        mapView.removeOverlays(mapView.overlays)
        var pt = [CLLocationCoordinate2D]()
        
        
        var annotations = mapView.annotations
        //var selectedAnnotations = mapView.selectedAnnotations
        for x in 1..<annotations.count + 1{
            for ant in annotations{
                if let pin = ant as? GridAnnotation {
                   if pin.identifier == x{
                       pt.append(pin.coordinate)
                   }
                }
                
                
            }
        }
        
        fourPoints = pt
        var polyline = MKPolyline(coordinates: pt, count: pt.count)
        mapView.addOverlay(polyline)
    
        
        let polygon = MKPolygon(coordinates: pt, count: pt.count)
        mapView.addOverlay(polygon)
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
            let pinView = DJIGridAnnotationView(annotation: annotation, reuseIdentifier: "Grid_Annotation")
            //pinView.pinTintColor = .purple
            pinView.image = UIImage(named:"plus2.png")
            pinView.canShowCallout = true
            pinView.isDraggable = true
           // pinView.animatesDrop = true
            return pinView
        } else if annotation is DJIAircraftAnnotation {
            let annoView = DJIAircraftAnnotationView(annotation: annotation, reuseIdentifier: "Aircraft_Annotation")
            (annotation as? DJIAircraftAnnotation)?.annotationView = annoView
            return annoView
        } else if annotation is DummyAircraftAnnotation {
            let annoView = DummyAircraftAnnotationView(annotation: annotation, reuseIdentifier: "DummyAircraft_Annotation")
            (annotation as? DummyAircraftAnnotation)?.annotationView = annoView
            return annoView
        }
//        else if annotation is GridAnnotation{
//            let gridpointView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Grid_Annotation")
//            gridpointView.image = UIImage(named: "plus.png")
//            gridpointView.isDraggable = true
//            gridpointView.canShowCallout = true
//            return gridpointView
//
//        }

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            print("Point Dragging Started")
            drawGrid()
        case .dragging:
            print("Point Dragging is dragging")
            drawGrid()
        case .canceling, .ending:
            print("Poinbt Dragging Canclled")
            drawGrid()
        default:
            print("Point Dragging Default case executed")
        }
    }
    
    
    
    
    // Apply this Method for Polygons and PolyLines on Map.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .green
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .lightGray
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
    
    func getCordinatesBetweenPoints(startPoint: CLLocationCoordinate2D , endPoint: CLLocationCoordinate2D)->[CLLocationCoordinate2D] {
        let yourTotalCoordinates = Double(5) //1 number of coordinates, change it as per your uses
        let latitudeDiff = startPoint.latitude - endPoint.latitude //2
        let longitudeDiff = startPoint.longitude - endPoint.longitude //3
        let latMultiplier = latitudeDiff / (yourTotalCoordinates + 1) //4
        let longMultiplier = longitudeDiff / (yourTotalCoordinates + 1) //5

        var array = [CLLocationCoordinate2D]()
        array.append(startPoint)//6
        for index in 1...Int(yourTotalCoordinates) { //7
            
            let lat  = startPoint.latitude - (latMultiplier * Double(index)) //8
            let long = startPoint.longitude - (longMultiplier * Double(index)) //9
            let point = CLLocationCoordinate2D(latitude: lat, longitude: long) //10
            array.append(point) //11
        }
        array.append(endPoint)
        print("all your coordinates: \(array)")
        return array
    }
    
    func fillGridPath(firstPoint: CLLocationCoordinate2D , secondPoint: CLLocationCoordinate2D , thirdPoint: CLLocationCoordinate2D , fourthPoint: CLLocationCoordinate2D){
        var top = true
        var gridFillarray = [CLLocationCoordinate2D]()
        var topLinePoints = getCordinatesBetweenPoints(startPoint: firstPoint, endPoint: secondPoint)
        var bottomLinePoints = getCordinatesBetweenPoints(startPoint: fourthPoint, endPoint: thirdPoint)
        for i in 0..<topLinePoints.count{
            if top{
                gridFillarray.append(topLinePoints[i])
                gridFillarray.append(bottomLinePoints[i])
                top = false
            }
            else{
                gridFillarray.append(bottomLinePoints[i])
                gridFillarray.append(topLinePoints[i])
                top = true
            }
        }
        self.dummySimulatorFlyPath = gridFillarray
        var polyline = MKPolyline(coordinates: gridFillarray, count: gridFillarray.count)
               mapView.addOverlay(polyline)
        
    }
}


