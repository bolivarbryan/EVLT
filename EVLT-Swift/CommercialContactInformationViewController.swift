//
//  CommercialContactInformationViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class CommercialContactInformationViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var streetLabel: UITextField!
    @IBOutlet weak var postalCodeLabel: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    
    var place: Place!
    var project: Project!
    override func viewDidLoad() {
        super.viewDidLoad()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = done
        
        self.cityLabel.text = place.city
        self.streetLabel.text = place.street
        self.numberLabel.text = "\(place.number)"
        self.postalCodeLabel.text = "\(place.postalCode)"
        self.fetchData()
    }
    
    func save() {
        if (self.place.coordinate.latitude == 0) && (self.place.coordinate.longitude == 0) {
            ELVTAlert.showMessage(controller: self, message: "Coordinates not found for this address", completion: { (done) in })
        }else {
            //saving information in server
            self.place.city = self.cityLabel.text!
            self.place.postalCode = Int(self.postalCodeLabel.text)
            let status = "FERME"
            APIRequests.coordinatesSite(project: self.project, place: self.place, status: status, completion: { (results) in
                DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                }
            })
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
     //TODO: use corelocation and reverse geocoding
        
    }

    @IBAction func next(_ sender: UITextField) {
        switch sender {
        case self.numberLabel:
            streetLabel.becomeFirstResponder()
        case self.streetLabel:
            postalCodeLabel.becomeFirstResponder()
        case self.postalCodeLabel:
            cityLabel.becomeFirstResponder()
        case self.cityLabel:
            self.view.endEditing(true)
        default:
            print("no")
        }
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
