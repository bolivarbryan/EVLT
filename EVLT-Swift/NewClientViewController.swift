//
//  NewClientViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 15/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kNewClient
        let newButton = UIBarButtonItem(title: kSaveString, style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = newButton
     
        capitalizeTextField(textFields: [firstNameTxt, lastNameTxt, address, streetTxt, postalCodeTxt, cityTxt, cellPhoneTxt, phoneTxt])
    }
    
    func capitalizeTextField(textFields: [UITextField]){
        for textField in textFields {
            textField.addTarget(self, action: #selector(textfieldValueChanged(textField:)), for: .editingChanged)
        }
    }
    
    func save() {
        if isValidForm() == true {
            //proceed to save user
            
        }else{
            ELVTAlert.showMessage(controller: self, message: kEmptyForm, completion: { (done) in
                
            })
        }
    }
    
    func isValidForm() -> Bool {
        var isValid = true
        isValid = (self.firstNameTxt.text?.characters.count)! > 0
        isValid = (self.lastNameTxt.text?.characters.count)! > 0
        isValid = (self.address.text?.characters.count)! > 0
        isValid = (self.streetTxt.text?.characters.count)! > 0
        isValid = (self.postalCodeTxt.text?.characters.count)! > 0
        isValid = (self.cityTxt.text?.characters.count)! > 0
        isValid = (self.cellPhoneTxt.text?.characters.count)! > 0
        isValid = (self.phoneTxt.text?.characters.count)! > 0
        isValid = (self.emailTxt.text?.characters.count)! > 0
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}
