//
//  Place.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 11/24/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import Foundation

struct Place {
    var siteID = 0
    var postalCode = 0
    var coordinate: Coordinate
    var number = 0
    var street = ""
    var city = ""
    var coordinateSiteId = 0
    var numberString: String?
    
    init(siteID: Int,postalCode: Int,coordinate:Coordinate, number: Int, street: String, city: String, coordinateSiteId:Int) {
        self.siteID = siteID
        self.postalCode = postalCode
        self.coordinate = coordinate
        self.number = number
        self.street = street
        self.city = city
        self.coordinateSiteId = coordinateSiteId
        self.numberString = "\(number)"
    }
    
    init(dictionary: Dictionary<String, Any>) {
        if  let codePostal = dictionary["code_postal"] as? Int {
            self.postalCode = codePostal
        }else{
            //formatting
            let numberFormmater = NumberFormatter()
            let codePostal = numberFormmater.number(from: dictionary["code_postal"] as! String)
            self.postalCode = (codePostal?.intValue)!
        }
        self.numberString = dictionary["numero"] as! String
        self.city = dictionary["ville"] as! String
        self.street = dictionary["rue"] as! String
        
        if let lat = dictionary["latitude"] as? Double {
                self.coordinate = Coordinate(latitude: dictionary["latitude"] as! Double, longitude: dictionary["longitude"] as! Double)
        }else{
            let numberFormmater = NumberFormatter()
            let lat = numberFormmater.number(from: dictionary["latitude"] as! String)
            let longitude = numberFormmater.number(from: dictionary["longitude"] as! String)
            self.coordinate = Coordinate(latitude: (lat?.doubleValue)!, longitude: (longitude?.doubleValue)!)
        }
    }
}

extension Place {
    func formattedAddress() -> String {
        return "\(self.numberString!), \(self.street), \(self.postalCode) \(self.city)"
    }
}
