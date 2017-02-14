//
//  LoginViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 12/6/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.autocorrectionType = .no
        self.password.autocorrectionType = .no
    }
    
    @IBAction func nextField(_ sender: Any) {
        self.password.becomeFirstResponder()
    }
    
    @IBAction func finsishPAssword(_ sender: Any) {
        self.password.resignFirstResponder()
        self.username.resignFirstResponder()
        login("")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if   let _ = UserDefaults.standard.value(forKey: KSessionData) {
            loginSuccessful()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(_ sender: Any) {
        var success =  (username.text?.characters.count)! > 0
        success =  (password.text?.characters.count)! > 0
     
        if success == true {
            APIRequests.login(username: username.text!, password: password.text!, completion:{ user in
                self.loginSuccessful()
            })
        }else{
            ELVTAlert.showMessage(controller: self, message: kEmptyForm, completion: { (done) in})
        }
    }

    func loginSuccessful() {
//        let user = User(dictionary: UserDefaults.standard.value(forKey: KSessionData) as! Dictionary<String, Any>)
//        let actionController = UIAlertController(title: kSuccessLogin, message: "\(kWelcomeLogin) \(user.profil)", preferredStyle: .alert)
//        let cancelAction: UIAlertAction = UIAlertAction(title: kOkString, style: .default) { action -> Void in
//            self.performSegue(withIdentifier: kLoginSegue, sender: self)
//        }
//
//        actionController.addAction(cancelAction)
        OperationQueue.main.addOperation{
            self.performSegue(withIdentifier: kLoginSegue, sender: self)

//            self.present(actionController, animated: true, completion: nil)
        }
    }
    
}
