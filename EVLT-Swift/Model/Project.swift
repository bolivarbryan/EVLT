//
//  Project.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 1/25/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

enum PriceTCC: String {
    case notAvailable = "N/A"
}

enum ProjectStatus: String {
    case active = "actif"
    case visitFait = "visite faite"
    case accepted = "accepte"
}

enum ProjectAdminStatus: String {
    case toBeProggramed = "A programmer"
}

class Project {
    var tva: Float = 0
    var prix_ttc: PriceTCC
    var type: String
    var statut_technicien: String
    var client_id: Int
    var contact: String
    var status: ProjectStatus
    var chantier_id: Int
    var statut_administratif: ProjectAdminStatus
    var prix_ht: Int
    
    //date
    var date_contact: Date
    var unite_temps: String?
    var duree_chantier: String?
    var comments: String?
    var technicians: Array<String>?
    
    init(tva: Float, prix_ttc: PriceTCC, type: String, date_contact:Date, statut_technicien:String, client_id: Int, contact:String, status: ProjectStatus, chantier_id: Int, statut_administratif: ProjectAdminStatus,  prix_ht: Int ) {
        self.tva = tva
        self.prix_ht = prix_ht
        self.prix_ttc = prix_ttc
        self.type = type
        self.date_contact = date_contact
        self.statut_technicien = statut_technicien
        self.client_id = client_id
        self.contact = contact
        self.status = status
        self.chantier_id = chantier_id
        self.statut_administratif = statut_administratif
    }
    
    init(dictionaryObject: Dictionary<String, Any>) {
        print(dictionaryObject)
        self.tva = Float(dictionaryObject["tva"] as! String) ?? 0
        self.prix_ht = Int(dictionaryObject["prix_ht"] as! String) ?? 0
        self.type = dictionaryObject["type"] as! String
        self.date_contact = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dictionaryObject["date"] as! String){
            self.date_contact = date
        }
        
        self.statut_technicien = dictionaryObject["statut"] as! String
        
        self.client_id = 0
        self.contact = ""
        self.status = ProjectStatus.init(rawValue: (dictionaryObject["statut"] as! String).lowercased()) ?? .active

        self.chantier_id = Int(dictionaryObject["chantier_id"] as! String)!
        self.statut_administratif = .toBeProggramed
        self.prix_ttc = PriceTCC.init(rawValue: dictionaryObject["prix_ttc"] as! String) ?? .notAvailable
        
        self.date_contact = EVLTDateFormatter.dateFromSring(string: dictionaryObject["date"] as! String)
        self.unite_temps = dictionaryObject["unite_temps"] as! String
        self.duree_chantier = dictionaryObject["duree_chantier"] as! String
        self.comments = dictionaryObject["commentaire"] as! String
    }
}

/*
 "tva" : "5,5 %",
 "prix_ttc" : "N\/A",
 "type" : "Installation Poêle Granul\u0000",
 "date_contact" : "0000-00-00",
 "statut_technicien" : "",
 "client_id" : "134",
 "contact" : "sms",
 "statut" : "Accepte",
 "chantier_id" : "209",
 "statut_administratif" : "A programmer",
 "prix_ht" : "0"
 */
