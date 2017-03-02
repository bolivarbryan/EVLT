//
//  EvltLocationManager.swift
//  EVLT-Swift
//
//  Created by Bryan on 15/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation
import CoreLocation
import AddressBookUI

class EvltLocationManager: NSObject {
    // Can't init is singleton
    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    //MARK: Shared Instance
    static let sharedInstance: EvltLocationManager = EvltLocationManager()
    var currentCoordinate: Coordinate? =  nil
    var locationManager : CLLocationManager!
    
    class func getLatLngForZip(zipCode: String) {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
        let apikey = "AIzaSyCGillSQqptoIa94nu36dT8oqKlo45FgZU"
        
        let url = NSURL(string: "\(baseUrl)address=\(zipCode)&key=\(apikey)")
        let data = NSData(contentsOf: url! as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        if let result = json["results"] as? NSArray {
            if result.count > 0 {
                if let geometry = result[0] as? NSDictionary{
                    if let geometry = geometry["geometry"] as? NSDictionary {
                        if let location = geometry["location"] as? NSDictionary {
                            let latitude = location["lat"] as! Float
                            let longitude = location["lng"] as! Float
                            print("\n\(latitude), \(longitude)")
                        }
                    }
                }
            }
        }
    }
    
    class func forwardGeocoding(address: String, completion: @escaping (_ lat:String, _ lng: String) -> Void) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error ?? "error!!")
                completion("\(0)", "\(0)")
                return
            }
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                completion("\(coordinate!.latitude)", "\(coordinate!.longitude)")
            }
        })
    }
    
    class func reverseGeocoding(coordinate: Coordinate, completion:@escaping (_ place: Place?) -> Void) {
        var place:Place? = nil
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                completion(place)
            }else{
                if let placemarkArray = placemarks {
                    for placemark in placemarkArray {
                        print(placemark)
                        place = Place(siteID: 0, postalCode: 0, coordinate: coordinate, number: 0, street: "", city: "", coordinateSiteId: 0)
                        place?.city = placemark.locality ?? ""
                        place?.numberString = placemark.name ?? ""
                        place?.street = placemark.thoroughfare ?? ""
                        if let pc = placemark.postalCode {
                           place?.postalCode = Int(pc) ?? 0
                        }
                        
                        completion(place)
                        break
                    }
                }
            }
        }
    }
    
    func startUpdatingLocation()  {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func currentLocationCoordinate() -> Coordinate? {
        if let cc = self.currentCoordinate {
            return cc
        }else{
            return nil
        }
    }
    
}

extension EvltLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.currentCoordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
}


extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
}
