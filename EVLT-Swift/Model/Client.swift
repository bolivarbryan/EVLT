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
    var status: ClientStatus? = nil
    var address: String? = ""
    
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
        
        self.address = ""
        self.address = (dictionary["numero"] as? String ?? "") + ", "
        self.address = self.address! + (dictionary["rue"] as? String ?? "") + ", "
        self.address = self.address! + (dictionary["code_postal"] as? String ?? "") + " "
        self.address = self.address! + (dictionary["ville"] as? String ?? "")
        
        let statusString = dictionary["statut"] as? String ?? "Visite faite"
        self.status = ClientStatus.init(rawValue: statusString)
    }
}

extension Client {
    func fullName() -> String {
        return "\(self.lastName) \(self.name)".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    enum ClientStatus: String{
        case visit = "Visite faite"
        case appointment = "Actif"
        case accepted = "Accepte"
        case refuse = "Inactif"
        case all = "All"
    }
}
