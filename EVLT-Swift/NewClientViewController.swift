//
//  NewClientViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 15/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

protocol NewClientDelegate {
    func clientSuccessfullyCreated()
    func clientCanceled()
}

class NewClientViewController: UIViewController {
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var streetTxt: UITextField!
    @IBOutlet weak var postalCodeTxt: UITextField!
    @IBOutlet weak var cityTxt: UITextField!
    @IBOutlet weak var cellPhoneTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var delegate: NewClientDelegate!
    var selectedClient: Client? = nil
    var place: Place!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kNewClient
        let newButton = UIBarButtonItem(title: kSaveString, style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = newButton
        self.phoneTxt.delegate = self
        self.cellPhoneTxt.delegate = self
        capitalizeTextField(textFields: [firstNameTxt, lastNameTxt, address, streetTxt, postalCodeTxt, cityTxt, cellPhoneTxt, phoneTxt])
        
        self.firstNameTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.lastNameTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.address.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.streetTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.postalCodeTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.cityTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.cellPhoneTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.phoneTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.emailTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        
        if let client = selectedClient {
            
            //TODO: Translate this
            self.title = NSLocalizedString("Edit Client", comment: "")
            
            //getting user address
            APIRequests.getClient(clientID: client.clientID, completion: { (results) in
                DispatchQueue.main.async {
                    //getting phones
                    self.firstNameTxt.text = (results["client"] as! Client).name
                    self.lastNameTxt.text = (results["client"] as! Client).lastName
                    self.cellPhoneTxt.text = (results["client"] as! Client).cellPhone
                    self.phoneTxt.text = (results["client"] as! Client).phone
                    
                    //filling other fields
                    let place = results["place"] as! (lat:String, longitude:String, postal: String, number:String, street:String, city:String, siteID:String, email:String )
                    
                    self.address.text = place.number
                    self.postalCodeTxt.text = place.postal
                    self.cityTxt.text = place.city
                    self.streetTxt.text = place.street
                    self.emailTxt.text = place.email
                }
            })
        }
    }
    
    @IBAction func next(_ sender: UITextField)  {
        switch sender {
        case firstNameTxt:
            lastNameTxt.becomeFirstResponder()
        case lastNameTxt:
            address.becomeFirstResponder()
        case address:
            streetTxt.becomeFirstResponder()
        case streetTxt:
            postalCodeTxt.becomeFirstResponder()
        case postalCodeTxt:
            cityTxt.becomeFirstResponder()
        case cityTxt:
            cellPhoneTxt.becomeFirstResponder()
        case cellPhoneTxt:
            phoneTxt.becomeFirstResponder()
        case phoneTxt:
            emailTxt.becomeFirstResponder()
        case emailTxt:
            self.view.endEditing(true)
    
        default:
            print("none")
        }
    }
    
    func capitalizeTextField(textFields: [UITextField]){
        for textField in textFields {
            textField.addTarget(self, action: #selector(textfieldValueChanged(textField:)), for: .editingChanged)
        }
    }
    
    func save() {
        if isValidForm() == true {
            //proceed to save user
            let formattedAddress = "\(address.text!) \(streetTxt.text!),\(postalCodeTxt.text!) \(cityTxt.text!)"
            EvltLocationManager.forwardGeocoding(address: formattedAddress, completion: { (lat, lng) in
                var status = "CREATION"
                if self.selectedClient != nil {
                    status = "EXISTE"
                }
                APIRequests.newClient(status:status, clientID: self.selectedClient?.clientID, firstName: self.firstNameTxt.text!, lastName: self.lastNameTxt.text!, addressNumber: self.address.text!, street: self.streetTxt.text!, postalCode: self.postalCodeTxt.text!, city: self.cityTxt.text!, cellphone: self.cellPhoneTxt.text!, phone: self.phoneTxt.text!, email: self.emailTxt.text!, latidude: lat, longitude: lng, completion: { (client) in
                    
                    print("created: \(client) ")
                     DispatchQueue.main.async {
                    if self.selectedClient != nil {
                        //client update, just pop
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        //new client
                         self.selectedClient = client
                        //proceed to see new project view
                        self.delegate.clientSuccessfullyCreated()
                        self.navigationController?.popViewController(animated: true)
                    }
                    }
                })
            })
        }else{
//            if !isValidEmail(testStr: self.emailTxt.text!) {
//                ELVTAlert.showMessage(controller: self, message: kInvalidEmail, completion: { (done) in  
//                })
//            }else{
                ELVTAlert.showMessage(controller: self, message: kEmptyForm, completion: { (done) in })
//            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidForm() -> Bool {
        var isValid = true
        isValid = (self.firstNameTxt.text?.characters.count)! > 0
        isValid = (self.lastNameTxt.text?.characters.count)! > 0
        isValid = (self.address.text?.characters.count)! > 0
        isValid = (self.streetTxt.text?.characters.count)! > 0
        isValid = (self.postalCodeTxt.text?.characters.count)! > 0
        isValid = (self.cityTxt.text?.characters.count)! > 0
        //isValid = (self.cellPhoneTxt.text?.characters.count)! > 0
        //isValid = (self.phoneTxt.text?.characters.count)! > 0
        
        //only verify if email is valid if there is a string, now email will not be compulsory
        if (self.emailTxt.text?.characters.count)! > 0 {
            isValid = isValidEmail(testStr: self.emailTxt.text!)
        }
        
        return isValid
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextField(_ sender: UITextField) {
        var scrollConstant = 0
        switch sender {
        case self.firstNameTxt:
            self.lastNameTxt.becomeFirstResponder()
            scrollConstant = 0
        case self.lastNameTxt:
            self.address.becomeFirstResponder()
            scrollConstant = 0
        case self.address:
            self.streetTxt.becomeFirstResponder()
            scrollConstant = 150
        case self.streetTxt:
            self.postalCodeTxt.becomeFirstResponder()
            scrollConstant = 200
        case self.postalCodeTxt:
            self.cityTxt.becomeFirstResponder()
            scrollConstant = 200
        case self.cityTxt:
            self.cellPhoneTxt.becomeFirstResponder()
            scrollConstant = 350
        case self.cellPhoneTxt:
            self.phoneTxt.becomeFirstResponder()
            scrollConstant = 350
        case self.phoneTxt:
            self.emailTxt.becomeFirstResponder()
            scrollConstant = 400
        case self.emailTxt:
            view.endEditing(true)
        default:
            print("none")
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollConstant)
        }
    }

    
    @IBAction func focusOnField(_ sender: UITextField) {
        var scrollConstant = 0
        switch sender {
        case self.firstNameTxt:
            scrollConstant = 0
        case self.lastNameTxt:
            scrollConstant = 0
        case self.address:
            scrollConstant = 0
        case self.streetTxt:
            scrollConstant = 150
        case self.postalCodeTxt:
            scrollConstant = 200
        case self.cityTxt:
            scrollConstant = 200
        case self.cellPhoneTxt:
            scrollConstant = 350
        case self.phoneTxt:
            scrollConstant = 350
        case self.emailTxt:
            scrollConstant = 400

        default:
            print("none")
        }
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollConstant)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "projectsSegue" {
//            let vc = segue.destination as! NewProjectViewController
//            vc.client = selectedClient
//        }
        
    }


    
    
}

extension NewClientViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = textField.text?.capitalized
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?.capitalized
    }
    
    func textfieldValueChanged(textField: UITextField) {
        textField.text = textField.text?.capitalized
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        var valid = allowedCharacters.isSuperset(of: characterSet)
        
        if valid == false {
            //newline
            let allowedCharacters = CharacterSet.newlines
            let characterSet = CharacterSet(charactersIn: string)
            valid = allowedCharacters.isSuperset(of: characterSet)
        }
        
        return valid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    

}


extension NewClientViewController {
    //MARK: Location
    @IBAction func getCurrentLocation(_ sender: Any) {
        //TODO: use corelocation and reverse geocoding
        if let testCoordinate = EvltLocationManager.sharedInstance.locationManager.location {
            EvltLocationManager.reverseGeocoding(coordinate: Coordinate(latitude: testCoordinate.coordinate.latitude, longitude: testCoordinate.coordinate.longitude)) { (place) in
                self.place = place
                self.fillData()
            }
        }
    }
    
    func  fillData() {
        self.cityTxt.text = place.city
        self.streetTxt.text = place.street
        self.address.text = "\(place.numberString!)"
        self.postalCodeTxt.text = "\(place.postalCode)"
        self.fetchData()
    }
 
    func fetchData() {
        //reverse geocoding from current place
        let formattedAddress = "\(place.number) \(place.street),\(place.postalCode) \(place.city)"
        EvltLocationManager.forwardGeocoding(address: formattedAddress, completion: { (lat, lng) in
            print(lat)
            print(lng)
            self.place.coordinate.latitude = Double(lat) ?? 0
            self.place.coordinate.longitude = Double(lng) ?? 0
        })
    }
    
}
