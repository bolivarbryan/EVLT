//
//  Price.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 11/24/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import Foundation

struct Price {
    var siteID = 0
    var lessCapital:Float = 0
    var plusValues:Float = 0
    var percentageDue = ""
    var priceSiteID = 0
    var priceHT = ""
    var priceTCC = ""
    var statusPayment = ""
    var tva = 0.0
    var clientID: Int?
    
    init(siteID: Int, lessCapital: Float, plusValues: Float, percentageDue: String, priceSiteID: Int, priceHT: String, priceTCC: String, statusPayment: String, tva: Double, clientID: Int? = nil) {
        self.siteID = siteID
        self.lessCapital = lessCapital
        self.plusValues = plusValues
        self.percentageDue = percentageDue
        self.priceSiteID = priceSiteID
        self.priceHT = priceHT
        self.priceTCC = priceTCC
        self.statusPayment = statusPayment
        self.tva = tva
        self.clientID = clientID
    }
}
