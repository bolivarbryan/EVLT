//
//  Calendar.swift
//  EVLT-Swift
//
//  Created by Bryan Andres Bolivar Martinez on 6/11/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct EVLTCalendar {
    var chantierID: String
    var duration: Int
    var unit: String
    
    init(chantierID: String, duration: Int, unit: String) {
        self.chantierID = chantierID
        self.duration = duration
        self.unit = unit
    }
    
    init(dictionary: [String: Any]) {
        self.chantierID = dictionary["date_chantier_id"] as! String
        self.duration = dictionary["duree_chantier"] as! Int
        self.unit = dictionary["unite_temps"] as! String
    }
}
