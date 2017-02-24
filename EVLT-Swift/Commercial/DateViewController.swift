//
//  DateViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!
    
    //TODO: translate this
    let hourOptions = ["Heure(s)", "Jour(s)", "Semaine(s)"]
    
    //max number of hours, change its value for your requirements
    let kMaxCount = 999
    
    var project: Project!
    var date: Date! = Date()
    var duration: String!
    var quantity = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
        //minimum date, should be today. 
        self.datePicker.minimumDate = Date()
        
        //default selection
        duration = hourOptions[0]
    }
    
    func new() {
        //API Request
        APIRequests.createDateOfProject(project: self.project, status: "FERME", date: EVLTDateFormatter.stringFromDate(date: date), unit: duration, duration: "\(quantity)") { (value    ) in
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//MARK: Configure picker information here
extension DateViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            //type of duration, hourOptions
            return hourOptions[row]
        }else{
            //quantity
            return "\(row + 1)"
        }
    }
}

extension DateViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1{
            duration = hourOptions[row]
        }else{
            quantity = row + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return hourOptions.count
        }else{
            return kMaxCount
        }
    }
}

//MARK: DatePicker Methods

extension DateViewController {
   @IBAction func datePickerValueChanged() {
        self.date = self.datePicker.date
    }
}
