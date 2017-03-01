//
//  Client.swift
//  EVLT-Swift
//
//  Created by Bryan on 6/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct Client {
    var name:String
    var lastName: String
    var clientID: String
    var commercialActice: Bool
    var commercial: String
    var phone: String? = ""
    var cellPhone: String? = ""
    init(name: String, lastName: String, clientID: String, commercialActiveString:String, commercial: String) {
        self.name = name
        self.lastName = lastName
        self.clientID = clientID
        self.commercialActice = (commercialActiveString == "OUI")
        self.commercial = commercial
    }
    
    init(dictionary: Dictionary<String, Any>) {
        self.name = dictionary["prenom"] as? String ?? ""
        self.lastName = dictionary["nom"] as? String ?? ""
        self.clientID = dictionary["client_id"] as? String ?? ""
        self.commercial = dictionary["commercial"] as? String ?? ""
        if let active =  dictionary["commercial"] as? String {
            self.commercialActice = (active == "OUI")
        }else{
            self.commercialActice = false
        }
        
    }
}

extension Client {
    func fullName() -> String {
        return "\(self.lastName) \(self.name)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
