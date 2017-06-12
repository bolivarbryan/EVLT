//
//  APIRequests.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit
import Alamofire
import DGActivityIndicatorView
import Toaster
import CoreData
import SwiftyJSON

let apiDebugEnabled: Bool = true

class APIRequests: NSObject {

    //MARK: - GET METHODS
    class func simpleGet(endpoint:String, completion: ((_ result : NSDictionary ) -> Void)?){ // basic get request using alamofire library and a custom Activity indicator view

        var activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        let aiView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

        activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        activityIndicatorView?.startAnimating()
        aiView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        aiView.addSubview(activityIndicatorView!)
        UIApplication.shared.keyWindow?.addSubview(aiView)
        aiView.isHidden = false

        Alamofire.request(serverURL + endpoint).response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                if let appsDictionary = Serializer.convertStringToDictionary(text: utf8Text) {
                    completion! (appsDictionary as NSDictionary)
                }else{
                    completion! (["error":"Response Error"])
                    Toast(text: "Response Error").show()
                }
            }

            aiView.isHidden = true
            activityIndicatorView?.removeFromSuperview()
        }

    }

    //MARK: - POST METHODS

    class func simplePost(endpoint:String, parameters: NSDictionary, completion: ((_ result : [String:AnyObject]) -> Void)?){ // basic get request using alamofire library and a custom Activity indicator view

        var activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        let aiView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

        activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        activityIndicatorView?.startAnimating()
        aiView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        aiView.addSubview(activityIndicatorView!)
        UIApplication.shared.keyWindow?.addSubview(aiView)
        aiView.isHidden = false
        print(parameters)



        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        Alamofire.request(endpoint, method: .post, parameters: parameters as? Parameters, encoding:  JSONEncoding.default, headers: headers).response { (complete) in
            if let data = complete.data, let utf8Text = String(data: data, encoding: .utf8) {
                print(utf8Text)
                if let appsDictionary = Serializer.convertStringToDictionary(text: utf8Text) {
                    completion! (appsDictionary as [String: Any] as [String : AnyObject])
                }else{
                    do {
                        // convert data to string
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                        print(jsonObject)
                        completion! (["response": jsonObject as AnyObject])

                    } catch let error {
                        print(error)
                        completion!(["error":"Response Error" as AnyObject] )
                        Toast(text: "Response Error").show()
                    }
                }
            }
            aiView.isHidden = true
            DispatchQueue.main.async {
                activityIndicatorView?.removeFromSuperview()
            }
        }
    }

    //TODO: move this code
    class func sendForm(url: String, postData: NSMutableData, completion: ((_ result : [String:AnyObject]) -> Void)?){

        var activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        let aiView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))

        activityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.lineScalePulseOutRapid, tintColor: UIColor.white, size: 50)
        activityIndicatorView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        activityIndicatorView?.startAnimating()
        aiView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        aiView.addSubview(activityIndicatorView!)
        UIApplication.shared.keyWindow?.addSubview(aiView)
        aiView.isHidden = true

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                aiView.isHidden = true
                DispatchQueue.main.async {
                    activityIndicatorView?.removeFromSuperview()
                }
                } else {
                let json = JSON(data: data!)
                print(json)
                if json.dictionaryObject != nil {
                    completion!(json.dictionaryObject! as [String : AnyObject])
                }else{
                    completion!(["results": json.arrayObject as AnyObject])
                }
                aiView.isHidden = true
                DispatchQueue.main.async {
                    activityIndicatorView?.removeFromSuperview()
                }
            }
        })

        dataTask.resume()
    }


    //  MARK: - REQUESTS
    class func login(username: String, password: String, completion: ((_ result : User ) -> Void)?){

        //using Postman api
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "2e2b28c6-bd29-5757-9e45-7e0ecb822fa8",
            "content-type": "application/x-www-form-urlencoded"
        ]

        let postData = NSMutableData(data: "login=ns".data(using: String.Encoding.utf8)!)
        postData.append("&password=ns".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: serverURL + APIconnect+"?login=\(username)&password=\(password)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
            } else {
                let json = JSON(data: data!)
                if let username = json["login"].string {
                    if let profile = json["profil"].string {
                        let defaults = UserDefaults.standard
                        let user = User(username: username, profil: profile)
                        defaults.set(user.dictionaryValue(), forKey: KSessionData)
                        completion!(user)
                    }
                }


            }
        })

        dataTask.resume()

    }

    class func importAllPayments(completion: @escaping (_ result: [Payment]) ->  Void) {
        APIRequests.simplePost(endpoint: serverURL + APIImportAllPayments, parameters: [:]){ response in
            printResponse(response: response as AnyObject)

            let payments = (response["response"] as! Array<Dictionary<String, Any>>).map { paymentObject in
                return Payment(dictionary: paymentObject)
            }

            completion(payments)
        }
    }

    class func importAllPrices(completion: ((_ result : [Price] ) -> Void)?){
        APIRequests.simplePost(endpoint: serverURL + APIimportAllPrices, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
            let arrayOfPrices = APIRequests.serializeAnyToArray(object: response)
            var prices = [Price]()

            for priceObject in arrayOfPrices {
                let siteID = Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "chantier_id") as! String)
                let lessCapital = Serializer.convertStringToDouble(string: (priceObject as! NSDictionary).object(forKey: "moins_values") as! String)
                let plusValues =  Serializer.convertStringToDouble(string: (priceObject as! NSDictionary).object(forKey: "plus_values") as! String)
                let percentageDue = (priceObject as! NSDictionary).object(forKey: "pourcentage_exigible") as! String
                let priceSiteID = Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "prix_chantier_id") as! String)
                let priceHT = (priceObject as! NSDictionary).object(forKey: "prix_ht") as! String
                let priceTCC = (priceObject as! NSDictionary).object(forKey: "prix_ttc") as! String
                let statusPayment = (priceObject as! NSDictionary).object(forKey: "statut_paiement") as! String
                let tva = Serializer.convertStringToDouble(string: (priceObject as! NSDictionary).object(forKey: "prix_chantier_id") as! String)

                let price = Price(siteID: siteID, lessCapital: Float(lessCapital), plusValues: Float(plusValues), percentageDue: percentageDue, priceSiteID: priceSiteID, priceHT: priceHT, priceTCC: priceTCC, statusPayment: statusPayment, tva: tva)

                prices.append(price)

            }

            print(prices)
            completion!(prices)

        }
    }

    class func paymentProject(clientID:String, status:String, montant:String, date:String, mode:String, info:String, completion: @escaping (_ done: Bool) -> Void){

//        let params = "client_id=\(clientID)&statut=\(status)&montant=\(montant)&date=\(date)&mode=\(mode)&info=\(info)"
//
//        APIRequests.simplePost(endpoint: serverURL + APIpaymentProject + params , parameters: [:]){ response in
//            printResponse(response: response as AnyObject)
//            completion(true)
//        }
//
        let postData = NSMutableData()
        postData.append("client_id=\(clientID)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=\(status)".data(using: String.Encoding.utf8)!)
        postData.append("&montant=\(montant)".data(using: String.Encoding.utf8)!)
        postData.append("&date=\(date)".data(using: String.Encoding.utf8)!)
        postData.append("&mode=\(mode)".data(using: String.Encoding.utf8)!)
        postData.append("&info=\(info)".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIpaymentProject + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(true)
        }

    }

    class func startFilling(completion: ((_ result : [Client] ) -> Void)?){
        APIRequests.simplePost(endpoint: serverURL + APIstartFilling, parameters: [:]){ response in
            var clients: [Client] = []
            print(response)
            guard let array = response["response"] as? Array<Dictionary<String, Any>> else {
                completion!(clients)
                return
            }

            for clientDictionary in array {
                let client = Client(dictionary: clientDictionary)
                clients.append(client)
            }
            completion!(clients)
        }
    }

    class func importAllCoordinates(completion: ((_ result : [Place] ) -> Void)?){
        APIRequests.simplePost(endpoint: serverURL + APIimportAllCoordinates, parameters: [:]){ response in
            // parsing response
            let arrayOfPlaces = APIRequests.serializeAnyToArray(object: response)
            var places = [Place]()

            for placeObject in arrayOfPlaces {

                //integers
                let siteID =  Serializer.convertStringToInteger(string: (placeObject as! NSDictionary).object(forKey: "chantier_id") as! String)
                let postalCode = Serializer.convertStringToInteger(string: (placeObject as! NSDictionary).object(forKey: "code_postal") as! String)
                let number = Serializer.convertStringToInteger(string: (placeObject as! NSDictionary).object(forKey: "numero") as! String)
                let coordinateSiteId = Serializer.convertStringToInteger(string: (placeObject as! NSDictionary).object(forKey: "coordonnees_chantier_id") as! String)

                //double and coordinate
                let latitude = Serializer.convertStringToDouble(string: (placeObject as! NSDictionary).object(forKey: "latitude") as! String)
                let longitude = Serializer.convertStringToDouble(string: (placeObject as! NSDictionary).object(forKey: "longitude") as! String)
                let coordinate = Coordinate(latitude: latitude, longitude: longitude)

                //strings
                let street = (placeObject as! NSDictionary).object(forKey: "rue") as! String
                let city = (placeObject as! NSDictionary).object(forKey: "ville") as! String

                //creating instance
                let place = Place(siteID: siteID, postalCode: postalCode, coordinate: coordinate, number: number, street: street, city: city, coordinateSiteId:coordinateSiteId)

                places.append(place)
            }
            completion!(places)

        }
    }

    class func saveComment(project: Project, comment: String,author: String, completion: @escaping (_ results: Any) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(project.chantier_id)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=FERME".data(using: String.Encoding.utf8)!)
        postData.append("&commentaire=\(comment)".data(using: String.Encoding.utf8)!)
        postData.append("&auteur=\(author)".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIComments + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(response as AnyObject)
        }

    }

    class func editComment(comment:String, commentID: String, completion: @escaping (_ results: Any) -> Void ) {
        let postData = NSMutableData()
        postData.append("&commentaire=\(comment)".data(using: String.Encoding.utf8)!)
        postData.append("&id=\(commentID)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=EDIT".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIComments + "?"
        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(response as AnyObject)
        }
    }

    class func deleteComment(id: String, completion: @escaping (_ results: Any) -> Void ) {
        let postData = NSMutableData()
        postData.append("id=\(id)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=DELETE".data(using: String.Encoding.utf8)!)
        let url = serverURL + APIComments + "?"
        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(response as AnyObject)
        }
    }

    class func getComments(project: Project, completion: @escaping (_ results: Any) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(project.chantier_id)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=OUVRE".data(using: String.Encoding.utf8)!)
        let url = serverURL + APIComments + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(response as AnyObject)
        }

    }

    class func coordinatesSite(project:Project, place: Place, status: String, completion: @escaping (_ results: Any) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(project.chantier_id)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=\(status)".data(using: String.Encoding.utf8)!)
        postData.append("&numero=\(place.number)".data(using: String.Encoding.utf8)!)
        postData.append("&rue=\(place.street)".data(using: String.Encoding.utf8)!)
        postData.append("&codePostal=\(place.postalCode)".data(using: String.Encoding.utf8)!)
        postData.append("&ville=\(place.city)".data(using: String.Encoding.utf8)!)
        postData.append("&latitude=\(place.coordinate.latitude)".data(using: String.Encoding.utf8)!)
        postData.append("&longitude=\(place.coordinate.longitude)".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIcoordinatesSite + "?"
        print(project)
        print(place)

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
           completion(response as AnyObject)
        }

    }

    class func projectNetwork(ecs: ECS, action: String, chantierID: String, completion: @escaping () -> Void){
        print(ecs)
        print(action)
        print(chantierID)

        let postData = NSMutableData()
        postData.append("chantier_id=\(chantierID)".data(using: String.Encoding.utf8)!)
        postData.append("&action=\(action)".data(using: String.Encoding.utf8)!)

        postData.append("&type=\(ecs.type)".data(using: String.Encoding.utf8)!)
        postData.append("&nom=\(ecs.name)".data(using: String.Encoding.utf8)!)
        postData.append("&existe=\(ecs.existant)".data(using: String.Encoding.utf8)!)
        postData.append("&radiateur=\(ecs.radiateur)".data(using: String.Encoding.utf8)!)
        postData.append("&cuivre=\(ecs.material)".data(using: String.Encoding.utf8)!)
        postData.append("&diametre=\(ecs.diameter)".data(using: String.Encoding.utf8)!)


        if action == kActionTypeUpdate {
            postData.append("&reseau_id=\(ecs.ecsID)".data(using: String.Encoding.utf8)!)
        }


        let url = serverURL + APIprojectNetwork + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion()
        }

    }

    class func projectStatus(project: Project, statusTechnician: String, percentage: String, completion: @escaping () -> Void){

        var etat = project.status.rawValue
        etat = etat.capitalizingFirstLetter()

        let postData = NSMutableData()
        postData.append("chantier_id=\(project.chantier_id)".data(using: String.Encoding.utf8)!)
        postData.append("&etat=\(etat)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=\(project.statut_technicien)".data(using: String.Encoding.utf8)!)
        postData.append("&prix=\(project.prix_ht)".data(using: String.Encoding.utf8)!)
        postData.append("&tva=\(project.tva)".data(using: String.Encoding.utf8)!)
        postData.append("&statutAdmin=\(project.statut_administratif.rawValue)".data(using: String.Encoding.utf8)!)
        postData.append("&proggress=\(percentage)".data(using: String.Encoding.utf8)!)

        if etat == "Accepte" {
            //prevú

            postData.append("&statut_technicien=\(statusTechnician)".data(using: String.Encoding.utf8)!)
        }

        let url = serverURL + APIprojectStatus + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion()
        }
    }

    class func getDate(date: Date, completion: @escaping (_ result: Any?) -> Void) {
        let postData = NSMutableData()
        //Format for date: yyyy-mm-dd
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = formatter.string(from: date)
        postData.append("statut=LIST".data(using: String.Encoding.utf8)!)
        postData.append("&date=\(dateString)".data(using: String.Encoding.utf8)!)
        
        let url = serverURL + APIdate
        
        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            
            completion(response as [String:
                Any])
        }
    }

    class func createDateOfProject(project: Project, status: String, date: String, unit: String, duration: String, completion: @escaping (_ result: Any?) -> Void) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(project.chantier_id)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=\(status)".data(using: String.Encoding.utf8)!)
        postData.append("&date=\(date)".data(using: String.Encoding.utf8)!)
        postData.append("&unite=\(unit)".data(using: String.Encoding.utf8)!)
        postData.append("&duree=\(duration)".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIdate + "?" + "chantier_id=\(project.chantier_id)"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)

            completion(nil)
        }
    }

    class func importProjectDetails(chantierID: String, completion: @escaping (_ project: Project?, _ place: Place?) -> Void){

        let postData = NSMutableData(data:"chantier_id=\(chantierID)".data(using: String.Encoding.utf8)!)

        APIRequests.sendForm(url:serverURL + APIimportProjectDetails + "?", postData: postData){ response in
            printResponse(response: response as AnyObject)
            //maping object
            let projectObject = Project(dictionaryObject: response)

            let emptyCoordinate = Coordinate(latitude: 0, longitude: 0)
            let place = Place(siteID: 0, postalCode: Int(response["code_postal"] as! String) ?? 0, coordinate: emptyCoordinate, number: Int(response["numero"] as! String) ?? 0, street: response["rue"] as! String, city: response["ville"] as! String, coordinateSiteId: 0)

            completion(projectObject, place)
        }
    }

    class func importTechnicians(statut:String?, chantierID: String, completion: @escaping (_ technicians: [Technician]) -> Void){

        let postData = NSMutableData(data:"chantier_id=\(chantierID)".data(using: String.Encoding.utf8)!)
        if let s = statut {
            postData.append("&statut=\(s)".data(using: String.Encoding.utf8)!)
        }

        APIRequests.sendForm(url:serverURL + APIImportTechinician + "?", postData: postData){ response in
            printResponse(response: response as AnyObject)
            //maping object
            var technicians:[Technician] = []
            for object in response["results"] as! Array<Dictionary<String, Any>> {
                let technician = Technician(name: object["nom"] as! String, lastName: object["prenom"] as! String, pictureUrl: object["picture_url"] as! String, id: object["id"] as! String)
                technicians.append(technician)
            }

            completion(technicians)
        }
    }

    class func saveTechnicians(statut:String?, techicianID:String, chantierID: String, completion: @escaping (_ completed:Bool) -> Void){

        let postData = NSMutableData(data:"chantier_id=\(chantierID)".data(using: String.Encoding.utf8)!)
        postData.append("&technician_code=\(techicianID)".data(using: String.Encoding.utf8)!)
        if let s = statut {
            postData.append("&statut=\(s)".data(using: String.Encoding.utf8)!)
        }

        APIRequests.sendForm(url:serverURL + APIImportTechinician + "?", postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(true)
        }
    }

    class func deleteRecord(query: String, completion: @escaping (_ completed:Bool) -> Void){
        let postData = NSMutableData()
        postData.append("requete=\(query)".data(using: String.Encoding.utf8)!)

        //FIXME: use a dynamic session
        postData.append("&clientID=ns".data(using: String.Encoding.utf8)!)

        let url = serverURL + "delete_request.php" + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)

            completion(true)
        }
    }

    class func connect(){
        APIRequests.simplePost(endpoint: serverURL + APIconnect, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }

    class func getHeatingNetwork(type: String, projectID: String, completion: @escaping (_ results: [Network]) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&action=OUVRE".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIprojectNetwork + "?" + "chantier_id=\(projectID)" + "&action=OUVRE"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            var networks:[Network] = []

            //parsing data
            if let results = response["results"] as? Array<Dictionary<String, Any>> {
                for networkObject in results {
                    print(networkObject)
                    if (networkObject["type_reseau"] as! String) == "chauffage" {
                        var network = Network(existing: networkObject["reseau_existant"] as! String, radiators:  networkObject["reseau_radiateur"] as! String, material:  networkObject["reseau_cuivre"] as! String, diameter:  networkObject["reseau_diametre"] as! String)
                        network.name = networkObject["nom_reseau"] as? String
                        network.netWorkId = networkObject["reseau_id"] as? String
                        networks.append(network)
                    }
                }
            }

            completion(networks)
        }

    }

    class func getECS(type: String, projectID: String, completion: @escaping (_ results: [ECS]) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&action=OUVRE".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIprojectNetwork + "?" + "chantier_id=\(projectID)" + "&action=OUVRE"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            var ecsObjects:[ECS] = []

            //parsing data
            if let results = response["results"] as? Array<Dictionary<String, Any>> {
                for networkObject in results {

                    if (networkObject["type_reseau"] as! String) == "ECS" {
                        var ecs = ECS(name: networkObject["nom_reseau"] as! String, existant: networkObject["reseau_existant"] as! String, diameter:  networkObject["reseau_diametre"] as! String, material: networkObject["reseau_cuivre"] as! String)

                        ecs.ecsID = networkObject["reseau_id"] as! String
                        ecs.radiateur = networkObject["reseau_radiateur"] as! String


                        ecsObjects.append(ecs)
                    }
                }
            }

            completion(ecsObjects)
        }

    }

    class func createNetwork(action: String,  projectID: String, network: Network, completion: @escaping (_ results: [Network]) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&action=\(action)".data(using: String.Encoding.utf8)!)
        postData.append("&type=chauffage".data(using: String.Encoding.utf8)!)
        postData.append("&nom=\(network.name!)".data(using: String.Encoding.utf8)!)
        postData.append("&existe=\(network.existing)".data(using: String.Encoding.utf8)!)
        postData.append("&radiateur=\(network.radiators)".data(using: String.Encoding.utf8)!)
        postData.append("&cuivre=\(network.material)".data(using: String.Encoding.utf8)!)
        postData.append("&diametre=\(network.diameter)".data(using: String.Encoding.utf8)!)

        if let id = network.netWorkId {
            postData.append("&reseau_id=\(id)".data(using: String.Encoding.utf8)!)

        }
        let url = serverURL + APIprojectNetwork + "?" + "chantier_id=\(projectID)" + "&action=\(action)"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            let networks:[Network] = []
            completion(networks)
        }

    }

    class func zonesProject(projectID: String, completion: @escaping (_ results: [Zone]) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
          postData.append("&action=OUVRE".data(using: String.Encoding.utf8)!)

        let url = serverURL + APIzonesProject + "?" + "chantier_id=\(projectID)" + "&action=OUVRE"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            var zones:[Zone] = []

            //parsing data
            if let results = response["results"] as? Array<Dictionary<String, Any>> {
                for zoneObject in results {
                    var zone = Zone(name: zoneObject["nom_zone"] as! String, volume: zoneObject["volume_zone"] as! String, walls: zoneObject["iso_murs"] as! String, attic: zoneObject["iso_combles"] as! String, groundStaff: zoneObject["iso_rampants"] as! String, carpentry: zoneObject["menuiseries"] as! String)
                    zone.projectID = zoneObject["chantier_id"] as? String
                    zone.zoneID = zoneObject["zone_id"] as? String

                    zones.append(zone)
                }
            }

            completion(zones)
        }

    }

    class func createZoneProject(action: String,  projectID: String, zone: Zone, completion: @escaping (_ results: [Zone]) -> Void ) {

        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&action=\(action)".data(using: String.Encoding.utf8)!)
        postData.append("&combles=\(zone.attic)".data(using: String.Encoding.utf8)!)
        postData.append("&rampants=\(zone.groundStaff)".data(using: String.Encoding.utf8)!)
        postData.append("&volume=\(zone.volume)".data(using: String.Encoding.utf8)!)
        postData.append("&menuiseries=\(zone.carpentry)".data(using: String.Encoding.utf8)!)
        postData.append("&nom=\(zone.name)".data(using: String.Encoding.utf8)!)
        postData.append("&murs=\(zone.walls)".data(using: String.Encoding.utf8)!)

        if let id = zone.zoneID {
            postData.append("&zone_id=\(id)".data(using: String.Encoding.utf8)!)

        }
        let url = serverURL + APIzonesProject + "?" + "chantier_id=\(projectID)" + "&action=\(action)"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            var zones:[Zone] = []
            completion(zones)
        }

    }

    class func newClient(status: String, clientID:String?, firstName: String, lastName: String, addressNumber: String, street:String, postalCode: String, city: String, cellphone: String, phone: String, email: String, latidude: String, longitude: String, completion: ((_ result : Client ) -> Void)?){

        let user = User(dictionary: UserDefaults.standard.dictionary(forKey: KSessionData)!)

        let postData = NSMutableData(data:"&statut=\(status)".data(using: String.Encoding.utf8)!)
        postData.append("&commercial=\(user.username)".data(using: String.Encoding.utf8)!)
        postData.append("&nom=\(lastName)".data(using: String.Encoding.utf8)!)
        postData.append("&prenom=\(firstName)".data(using: String.Encoding.utf8)!)
        postData.append("&numero=\(addressNumber)".data(using: String.Encoding.utf8)!)
        postData.append("&rue=\(street)".data(using: String.Encoding.utf8)!)
        postData.append("&codePostal=\(postalCode)".data(using: String.Encoding.utf8)!)
        postData.append("&ville=\(city)".data(using: String.Encoding.utf8)!)
        postData.append("&latitude=\(latidude)".data(using: String.Encoding.utf8)!)
        postData.append("&longitude=\(longitude)".data(using: String.Encoding.utf8)!)
        postData.append("&telFixe=\(phone)".data(using: String.Encoding.utf8)!)
        postData.append("&telPortable=\(cellphone)".data(using: String.Encoding.utf8)!)
        postData.append("&email=\(email)".data(using: String.Encoding.utf8)!)

        if let c = clientID {
            postData.append("&client_id=\(c)".data(using: String.Encoding.utf8)!)

        }


        print(postData)
        APIRequests.sendForm(url: "http://www.envertlaterre.fr/PHP/nouveau_client.php?", postData: postData){ response in
            printResponse(response: response as AnyObject)

            let client = Client(name: firstName, lastName: lastName, clientID: response["client_id"] as! String, commercialActiveString: "OUI", commercial: user.username )
            completion!(client)
        }

    }

    class func getClient(clientID: String, completion: @escaping (_ result : Dictionary<String, Any>  ) -> Void) {

        let user = User(dictionary: UserDefaults.standard.dictionary(forKey: KSessionData)!)
        let postData = NSMutableData(data:"&statut=OUVRE".data(using: String.Encoding.utf8)!)

        postData.append("&client_id=\(clientID)".data(using: String.Encoding.utf8)!)

        APIRequests.sendForm(url: "http://www.envertlaterre.fr/PHP/nouveau_client.php?", postData: postData){ results in
            printResponse(response: results as AnyObject)
            for response in results["results"] as! Array<Dictionary<String, Any>> {
                var client = Client(name: response["nom"] as! String, lastName: response["prenom"] as! String, clientID: response["client_id"] as! String, commercialActiveString: "OUI", commercial: "")
                client.phone =  response["tel_fixe"] as! String
                client.cellPhone =  response["tel_portable"] as! String

                let latitude = response["latitude"] as! String
                let longitude = response["longitude"] as! String
                let postalCode = response["code_postal"] as! String
                let number = response["numero"] as! String
                let street = response["rue"] as! String
                let city = response["ville"] as! String
                let email = response["email"] as! String
                let coordinateSiteId = response["coordonnees_client_id"] as! String


                let place = (lat:latitude, longitude:longitude, postal: postalCode, number:number, street:street, city:city, siteID:coordinateSiteId, email: email )

                completion(["client": client, "place":place])
            }

        }

    }

    class func deleteRequest(){
        APIRequests.simplePost(endpoint: serverURL + APIdeleteRequest, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }

    class func newProject(projectID: String?, edit:Bool, type: String, client: Client, completion:@escaping (_ results: Any) -> Void){

        let postData = NSMutableData(data:"type=\(type)".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(client.clientID)".data(using: String.Encoding.utf8)!)

        if let pID = projectID {
            postData.append("&chantier_id=\(pID)".data(using: String.Encoding.utf8)!)
        }

        if edit == true {
            postData.append("&statut=EXISTE".data(using: String.Encoding.utf8)!)
        }


        APIRequests.sendForm(url:serverURL + APInewProject + "?", postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion(response as AnyObject)
        }
    }

    class func clientCoordinates(){
        APIRequests.simplePost(endpoint: serverURL + APIclientCoordinates, parameters: [:]){ response in
         printResponse(response: response as AnyObject)
        }
    }

    class func projectPhoto(projectID: String, status: String, photo: Photo, comment: String, completion:@escaping (_ results: Any) -> Void){
        let postData = NSMutableData()
        let imageUrl = photo.url
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=\(status)".data(using: String.Encoding.utf8)!)
        postData.append("&commentaire=\(comment)".data(using: String.Encoding.utf8)!)
        postData.append("&photo=\(imageUrl)".data(using: String.Encoding.utf8)!)
        postData.append("&photoID=\(imageUrl)".data(using: String.Encoding.utf8)!)

        if let id = photo.photoID {
            postData.append("&photoID=\(id)".data(using: String.Encoding.utf8)!)
        }

        let url = serverURL + APIprojectPhoto + "?"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            completion("")
        }

    }

    class func listPhotos(projectID: String, completion:@escaping (_ results: [Photo]) -> Void){
        let postData = NSMutableData()
        postData.append("chantier_id=\(projectID)".data(using: String.Encoding.utf8)!)
        postData.append("&statut=OUVRE".data(using: String.Encoding.utf8)!)


        let url = serverURL + APIprojectPhoto + "?" + "chantier_id=\(projectID)"

        APIRequests.sendForm(url: url, postData: postData){ response in
            printResponse(response: response as AnyObject)
            var photos:[Photo] = []
            for photoObject in (response["results"] as? Array<Dictionary<String, Any>>)! {
                var photo = Photo(url: photoObject["url_photo"] as! String , comment: photoObject["commentaire_photo"] as! String)
                photo.photoID = (photoObject["photos_chantier_id"] as! String)
                photos.append(photo)
            }
            completion(photos)
        }

    }

    class func basicPost(endpoint: String, params:Array<Dictionary<String, Any>>, completion: @escaping (_ result: JSON) -> Void){
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "authorization": "Token 2184328b4a5ffaca35902fd70fd3e7e96777cba0",
            "cache-control": "no-cache",
            "postman-token": "cb15bb06-0b30-3f5b-6d2b-2d85273d1185"
        ]

        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"

        var body = ""
        var error: NSError? = nil
        print(params)
        for param in params {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let filename = param["fileName"] {
                let contentType = param["content-type"]!
                do {
                    let fileContent = try String(contentsOfFile: filename as! String, encoding: String.Encoding.utf8)
                    if (error != nil) {
                        print(error)
                    }
                    body += "; filename=\"\(filename)\"\r\n"
                    body += "Content-Type: \(contentType)\r\n\r\n"
                    body += fileContent
                } catch {

                }

            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }

        let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                let json = JSON(data: data!)
                print(json)
                completion(json)
            }
        })

        dataTask.resume()
    }


    class func importProjectWithClientID(clientID:String, completion: @escaping (_ result: Array<Dictionary<String, Any>>) -> Void){
        let parameters = [
            [
                "name": "client_id",
                "value": clientID
            ]
        ]

        let url = "http://www.envertlaterre.fr/PHP/import_projet.php"
        DispatchQueue.main.async {
            basicPost(endpoint: url, params: parameters) { (result) in
                print(result.dictionaryValue["chantiers"]?.arrayObject )

                if  let chantiers = result.dictionaryValue["chantiers"]?.arrayObject {
                    print(chantiers)

                    //get my own chantier
                    var chantierObjects:[Dictionary<String, Any>] = []
                    for chantier in chantiers as! Array<Dictionary<String, Any>> {
                        print(chantier)
                        if chantier["client_id"] as! String == clientID {
                            chantierObjects.append(chantier)
                        }
                    }
                    completion(chantierObjects)
                }
            }
        }
    }

    class func importAllProjects(completion: @escaping (_ result: Dictionary<String, Any>) -> Void){

        let url = "http://www.envertlaterre.fr/PHP/import_projet.php"

        basicPost(endpoint: url, params: [["name":"", "value":""]]) { (result) in
            completion(result.dictionaryObject!)
        }
    }

    class func importProject(completion: @escaping (_ results: Any) -> Void) {
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "b6a0be50-b13d-d0fc-6e7c-6839fa72b636",
            "content-type": "application/x-www-form-urlencoded"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: serverURL + APIimportProject)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
            } else {
                let json = JSON(data: data!)
                print(json)
                completion((json.dictionaryObject!)["chantiers"] as! Array<Dictionary<String, Any>>)
            }
        })

        dataTask.resume()
    }


    class func getDirections(origin:Coordinate, destiny: Coordinate, completion: @escaping (_ results: String) -> Void ) {
        //TODO: Encrypt this key
        let code = "AIzaSyCGillSQqptoIa94nu36dT8oqKlo45FgZU"
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "092b0e6c-b01d-1ad0-a5ea-422ebf677891"
        ]
        let formattedOriginString = "\(origin.latitude),\(origin.longitude)"
        let formattedDestinyString = "\(destiny.latitude),\(destiny.longitude)"
        let request = NSMutableURLRequest(url: NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(formattedOriginString)&destination=\(formattedDestinyString)&key=\(code)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
            } else {
                let json = JSON(data: data!)
                print(json)

                //filtering directions
                guard let routeObjects = json.dictionaryObject?["routes"] as? Array<Dictionary<String, Any>> else {
                    return
                }
                if routeObjects.count > 0 {
                    completion((routeObjects[0]["overview_polyline"] as! Dictionary<String, Any>)["points"] as! String)
                }else {
                    completion("")
                }
            }
        })

        dataTask.resume()
    }

    // MARK: - CoreData methods

    class func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    //MARK: - Helper Methods

    class func printResponse(response: AnyObject){
        if apiDebugEnabled == true {
            print(response)
        }
    }

    class func serializeAnyToArray(object:Any) -> [Any] {
        if (object as! NSDictionary).object(forKey: "response") is Array<Any> {
            return(object as! NSDictionary).object(forKey: "response") as! [Any]
        }else{
            return []
        }
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
