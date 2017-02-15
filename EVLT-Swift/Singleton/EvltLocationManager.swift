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

class EvltLocationManager {
    
    
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
}
