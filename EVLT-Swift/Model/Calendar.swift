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
    var duration: Int? = 0
    var unit: String
    
    init(chantierID: String, duration: Int, unit: String) {
        self.chantierID = chantierID
        self.duration = duration
        self.unit = unit
    }
    
    init(dictionary: [String: Any]) {
        self.chantierID = dictionary["date_chantier_id"] as! String
        
        let formatter = NumberFormatter()
        let number = formatter.number(from: dictionary["duree_chantier"] as! String)
        
        self.duration = number?.intValue
        self.unit = dictionary["unite_temps"] as! String
    }
    
}
