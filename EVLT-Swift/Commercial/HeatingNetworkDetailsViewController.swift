//
//  HeatingNetworkDetailsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 19/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class HeatingNetworkDetailsViewController: UIViewController {
    var project: Project!
    var network: Network? = nil
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var existingTxt: UITextField!
    @IBOutlet weak var copperTxt: UITextField!
    @IBOutlet weak var diameterTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Network", comment: "")
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
        self.name.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.existingTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.copperTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        self.diameterTxt.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        
        
        if let n = self.network {
            self.name.text = n.name
            self.existingTxt.text = n.existing
            self.copperTxt.text = n.material
            self.diameterTxt.text = n.diameter
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func new() {
        var validForm = true
        
//        validForm = name.text!.characters.count > 0
//        validForm = existingTxt.text!.characters.count > 0
//        validForm = copperTxt.text!.characters.count > 0
//        validForm = diameterTxt.text!.characters.count > 0
//       
        if name.text == "" {
          name.text = "N/A"
        }
        
        if existingTxt.text == "" {
            existingTxt.text = "N/A"
        }
        
        if copperTxt.text == "" {
            copperTxt.text = "N/A"
        }
        
        if diameterTxt.text == "" {
            diameterTxt.text = "N/A"
        }
        
        name.text = name.text ?? "N/A"
        existingTxt.text = existingTxt.text ?? "N/A"
        copperTxt.text = copperTxt.text ?? "N/A"
        diameterTxt.text = diameterTxt.text ?? "N/A"
        
        if validForm == true {
            //API Request
            var netWorkObject = Network(existing: self.existingTxt.text!, radiators: "N/A", material: self.copperTxt.text!, diameter: self.diameterTxt.text!)
            
            netWorkObject.name = self.name.text
            var action = "NOUVEAU"
            if network != nil {
                action = "EXISTE"
                netWorkObject.projectId = network?.projectId
                netWorkObject.netWorkId = network?.netWorkId
            }
            
            APIRequests.createNetwork(action: action, projectID: "\(self.project.chantier_id)", network: netWorkObject, completion: { (n) in
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
            
         
        } else {
            ELVTAlert.showMessage(controller: self, message: NSLocalizedString("All fields are required", comment: ""), completion: { (done) in})
        }
        
    }

    @IBAction func next(_ sender: UITextField)  {
        switch sender {
        case name:
            existingTxt.becomeFirstResponder()
        case existingTxt:
            copperTxt.becomeFirstResponder()
        case copperTxt:
            diameterTxt.becomeFirstResponder()
        case diameterTxt:
            self.view.endEditing(true)
            
        default:
            print("none")
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
