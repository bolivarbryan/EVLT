//
//  AdministrativePaymentViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class AdministrativePaymentViewController: UIViewController {
    /* constants*/
    let paymentOptions = ["Chèque", "Virement", "Espèces"]
    var selectedPaymentIndex: Int?
    var composedPaymentInfo: ComposedPayment!
    
    /* Properties */
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ammountTextField: UITextField!
    @IBOutlet weak var paymentChoicePicker: UIPickerView!
    @IBOutlet weak var informationTextField: UITextField!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doValidation(_ sender: Any) {
     
        
        let paymentOption = (selectedPaymentIndex != nil) ? selectedPaymentIndex! : 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: datePicker.date)
        let paymentOptionString = paymentOptions[paymentOption]
        let amountString = (self.ammountTextField.text != "") ? self.ammountTextField.text:"0"
        
        APIRequests.paymentProject(clientID: self.composedPaymentInfo.client.clientID, status: "NOUVEAU", montant: amountString!, date: dateString, mode: paymentOptionString, info: self.informationTextField.text!, completion: { (done) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
    
        })
    }
    
    @IBAction func amountEditTextFieldHAsBegun(_ sender: Any) {
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            
            self.scrollViewBottomConstraint.constant = keyboardHeight - 50
            self.scrollView.layoutIfNeeded()
        }
    }
}

extension AdministrativePaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  paymentOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paymentOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPaymentIndex = row
    }
    
}

extension AdministrativePaymentViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        self.scrollViewBottomConstraint.constant = 0
        self.scrollView.layoutIfNeeded()
    }
}
