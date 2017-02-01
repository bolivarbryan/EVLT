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
}

enum ProjectAdminStatus: String {
    case toBeProggramed = "A programmer"
}

class Project {
    var tva: Float = 0
    var prix_ttc: PriceTCC
    var type: String
    var date_contact: Date
    var statut_technicien: String
    var client_id: Int
    var contact: String
    var status: ProjectStatus
    var chantier_id: Int
    var statut_administratif: ProjectAdminStatus
    var prix_ht: Int
    
    
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
