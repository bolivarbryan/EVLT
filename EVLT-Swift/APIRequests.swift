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
        
        Alamofire.request(endpoint, method: .post, parameters: parameters as? Parameters, encoding:  JSONEncoding.default, headers: nil).response { (complete) in
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
            activityIndicatorView?.removeFromSuperview()
        }
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
    
    class func importAllPrices(completion: ((_ result : [Price] ) -> Void)?){
        APIRequests.simplePost(endpoint: serverURL + APIimportAllPrices, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
            let arrayOfPrices = APIRequests.serializeAnyToArray(object: response)
            var prices = [Price]()
            
            for priceObject in arrayOfPrices {
                let siteID = Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "chantier_id") as! String)
                let lessCapital = Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "moins_values") as! String)
                let plusValues =  Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "plus_values") as! String)
                let percentageDue = (priceObject as! NSDictionary).object(forKey: "pourcentage_exigible") as! String
                let priceSiteID = Serializer.convertStringToInteger(string: (priceObject as! NSDictionary).object(forKey: "prix_chantier_id") as! String)
                let priceHT = (priceObject as! NSDictionary).object(forKey: "prix_ht") as! String
                let priceTCC = (priceObject as! NSDictionary).object(forKey: "prix_ttc") as! String
                let statusPayment = (priceObject as! NSDictionary).object(forKey: "statut_paiement") as! String
                let tva = Serializer.convertStringToDouble(string: (priceObject as! NSDictionary).object(forKey: "prix_chantier_id") as! String)
                
                let price = Price(siteID: siteID, lessCapital: lessCapital, plusValues: plusValues, percentageDue: percentageDue, priceSiteID: priceSiteID, priceHT: priceHT, priceTCC: priceTCC, statusPayment: statusPayment, tva: tva)
                
                prices.append(price)
                
            }

            completion!(prices)

        }
    }
    
    class func paymentProject(clientID:String, status:String, montant:String, date:String, mode:String, info:String){
        
        
        let params = "client_id=\(clientID)&statut=\(status)&montant=\(montant)&date=\(date)&mode=\(mode)&info=\(info)"
        
        APIRequests.simplePost(endpoint: serverURL + APIpaymentProject + params , parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func startFilling(completion: ((_ result : [Client] ) -> Void)?){
        APIRequests.simplePost(endpoint: serverURL + APIstartFilling, parameters: [:]){ response in
            var clients: [Client] = []
            for clientDictionary in response["response"] as! Array<Dictionary<String, Any>> {
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
    
    class func commentaires(){
        APIRequests.simplePost(endpoint: serverURL + APIcommentaires, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func coordinatesSite(){
        APIRequests.simplePost(endpoint: serverURL + APIcoordinatesSite, parameters: [:]){ response in
            
        }
    }
    
    class func projectNetwork(){
        APIRequests.simplePost(endpoint: serverURL + APIprojectNetwork, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func getDate(){
        APIRequests.simplePost(endpoint: serverURL + APIdate, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func importProjectDetails(){
        APIRequests.simplePost(endpoint: serverURL + APIimportProjectDetails, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func connect(){
        APIRequests.simplePost(endpoint: serverURL + APIconnect, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func zonesProject(){
        APIRequests.simplePost(endpoint: serverURL + APIzonesProject, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func newClient(firstName: String, lastName: String, addressNumber: String, street:String, postalCode: String, city: String, cellphone: String, phone: String, email: String){
        
        APIRequests.simplePost(endpoint: serverURL + APInewClient, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func deleteRequest(){
        APIRequests.simplePost(endpoint: serverURL + APIdeleteRequest, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    
    class func newProject(){
        APIRequests.simplePost(endpoint: serverURL + APInewProject, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func projectStatus(){
        APIRequests.simplePost(endpoint: serverURL + APIprojectStatus, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
        }
    }
    
    class func clientCoordinates(){
        APIRequests.simplePost(endpoint: serverURL + APIclientCoordinates, parameters: [:]){ response in
         printResponse(response: response as AnyObject)
        }
    }
    
    class func projectPhoto(){
        APIRequests.simplePost(endpoint: serverURL + APIprojectPhoto, parameters: [:]){ response in
            printResponse(response: response as AnyObject)
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
    
    class func importProject(){
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
