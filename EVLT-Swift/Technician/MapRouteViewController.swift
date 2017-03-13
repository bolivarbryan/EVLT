//
//  MapRouteViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 13/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

final class MapRouteViewController: UIViewController {
    //MARK: PROPERTIES
    var project: Project! = nil
    var address: Place! = nil
    var mapView: GMSMapView? = nil
    let locationManager: CLLocationManager = CLLocationManager()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = project.type
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50.0
        locationManager.startUpdatingLocation()
        
        configureMapView()
        placeDestinationMarker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: MAP
    func configureMapView() {
        let camera = GMSCameraPosition(target: coordinateFromAddress(), zoom: 8.0, bearing: 0, viewingAngle: 0.0)
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        mapView?.camera = camera
        mapView?.isMyLocationEnabled = true
        self.view = mapView
    }
    
    func placeDestinationMarker() {
        let marker = GMSMarker()
        marker.position = coordinateFromAddress()
        marker.title = self.project.type
        marker.map = mapView
    }
    
    func drawRoute(encondedPath: String) {
        //encondedPath is a encoded string of the route
        let path = GMSPath.init(fromEncodedPath: encondedPath)
        let singleLine = GMSPolyline.init(path: path)
        
        singleLine.strokeWidth = 7
        singleLine.strokeColor = UIColor.green
        singleLine.map = self.mapView
        self.view = self.mapView
    }
    
    func coordinateFromAddress() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: address.coordinate.latitude, longitude: address.coordinate.longitude)
    }
}
//MARK: Core Location
extension MapRouteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //drawRoute()
        guard let lastLocation = locations.last else {
            return
        }
        
        let origin = Coordinate(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        let destiny = address.coordinate
        
        APIRequests.getDirections(origin: origin, destiny: destiny) { (encondedPath) in
            DispatchQueue.main.async {
                self.drawRoute(encondedPath: encondedPath)
            }
        }
    }
    
    func startTrackingLocation() {
        
    }
    
    func stopTrackingLocation() {
        
    }
}
