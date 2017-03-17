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
        EvltLocationManager.sharedInstance.startUpdatingLocation()
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = done
        fillData()
    }
    
    func  fillData() {
        self.cityLabel.text = place.city
        self.streetLabel.text = place.street
        self.numberLabel.text = "\(place.numberString!)"
        self.postalCodeLabel.text = "\(place.postalCode)"
        self.fetchData()
    }
    
    func save() {
        //saving information in server
        self.place.city = self.cityLabel.text!
        self.place.postalCode = Int(self.postalCodeLabel.text!) ?? 0
        self.place.number = Int(self.numberLabel.text!) ?? 0
        self.place.street = self.streetLabel.text!
        let status = "FERME"
        let formattedAddress = "\(place.number) \(place.street),\(place.postalCode) \(place.city)"
        
        EvltLocationManager.forwardGeocoding(address: formattedAddress, completion: { (lat, lng) in
            self.place.coordinate.latitude = Double(lat) ?? 0
            self.place.coordinate.longitude = Double(lng) ?? 0
            if (self.place.coordinate.latitude == 0) && (self.place.coordinate.longitude == 0) {
                ELVTAlert.showMessage(controller: self, message: "Coordinates not found for this address", completion: { (done) in })
            }else {
                APIRequests.coordinatesSite(project: self.project, place: self.place, status: status, completion: { (results) in
                    DispatchQueue.main.async {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
     //TODO: use corelocation and reverse geocoding
        if let testCoordinate = EvltLocationManager.sharedInstance.locationManager.location {
            EvltLocationManager.reverseGeocoding(coordinate: Coordinate(latitude: testCoordinate.coordinate.latitude, longitude: testCoordinate.coordinate.longitude)) { (place) in
                self.place = place
                self.fillData()
            }
        }
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
