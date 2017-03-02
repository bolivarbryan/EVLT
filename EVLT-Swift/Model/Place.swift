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
}
