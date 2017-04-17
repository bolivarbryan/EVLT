//
//  Payment.swift
//  EVLT-Swift
//
//  Created by Bryan on 4/17/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct Payment {
    var clientID: String
    var date: String
    var info: String
    var mode: String
    var ammount: String
    var paymentID: String
    
    
    init(dictionary: Dictionary<String, Any>) {
        self.clientID = dictionary["client_id"] as! String
        self.date = dictionary["date"] as! String
        self.info = dictionary["info"] as! String
        self.mode = dictionary["mode"] as! String
        self.ammount = dictionary["montant"] as! String
        self.paymentID = dictionary["paiement_id"] as! String
    }
}
