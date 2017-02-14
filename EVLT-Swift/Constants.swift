//
//  Constants.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

let serverURL = "http://www.envertlaterre.fr/PHP/"

let APIimportAllPrices = "import_allPrix.php"
let APIpaymentProject = "paiement_projet.php"
let APIstartFilling = "remplissage_accueil.php"
let APIimportAllCoordinates = "import_allCoords.php"
let APIclientCoordinates = "coordonnees_client.php"

let APIcommentaires = "commentaires.php"
let APIcoordinatesSite = "coordonnees_chantier.php"
let APIprojectNetwork = "reseaux_projet.php"
let APIdate = "date.php"
let APIimportProjectDetails = "import_detail_projet.php"
let APIprojectPhoto = "photo_projet.php"
let APIimportProject = "import_projet.php"

let APIconnect = "connect.php"
let APIzonesProject = "zones_projet.php"
let APIdeleteRequest = "delete_request.php"
let APInewClient = "nouveau_client.php"
let APInewProject = "nouveau_projet.php"
let APIprojectStatus = "statut_projet.php"


//session Keys

let KSessionData = "UserSession" // user data: login, profil

//segues

let kLoginSegue = "LoginSegue"

//Strings


let kOkString = NSLocalizedString("login.ok", comment: "Ok")
let kSuccessLogin = NSLocalizedString("login.success", comment: "Login Successful")
let kWelcomeLogin = NSLocalizedString("login.welcome", comment: "Welcome")
let kNewClient = NSLocalizedString("clients.button.new.client", comment: "New Client")
let kLogout = NSLocalizedString("settings.logout", comment: "Logout")
let kSettingsTitle = NSLocalizedString("settings.title", comment: "")
let kAlertCancel = NSLocalizedString("alert.cancel", comment: "Cancel")
let kAlertOk = NSLocalizedString("alert.confirm", comment: "Confirm")
let kLogoutConfirm = NSLocalizedString("confirm.logout", comment: "Confirm")
let kEmptyForm = NSLocalizedString("message.empty.form", comment: "Confirm")
