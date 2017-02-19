//
//  ZoneDetailsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class ZoneDetailsViewController: UIViewController {
    var zone:Zone?
    var project: Project
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var volumeLabel: UITextField!
    @IBOutlet weak var wallsLabel: UITextField!
    @IBOutlet weak var atticLabel: UITextField!
    @IBOutlet weak var groundStaffLabel: UITextField!
    @IBOutlet weak var carpentryLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kNewZone
        self.volumeLabel.addTarget(self, action: #selector(next(_:)), for: .editingDidEndOnExit)
        
        let newButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }

    func new() {
        var validForm = true
        
        validForm = nameLabel.text!.characters.count > 0
        validForm = volumeLabel.text!.characters.count > 0
        validForm = wallsLabel.text!.characters.count > 0
        validForm = atticLabel.text!.characters.count > 0
        validForm = groundStaffLabel.text!.characters.count > 0
        validForm = carpentryLabel.text!.characters.count > 0

        if validForm == true {
            //API Request
            let zoneObject = Zone(name: self.nameLabel.text!, volume: self.volumeLabel.text!, walls: self.wallsLabel.text! , attic: self.atticLabel.text! , groundStaff: self.groundStaffLabel.text! , carpentry: self.carpentryLabel.text!)
            
            APIRequests.createZoneProject(projectID: "\(self.project.chantier_id)", zone: zoneObject, completion: { (zones) in
                //saved
                DispatchQueue.main.async {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            })
            
        } else {
            ELVTAlert.showMessage(controller: self, message: NSLocalizedString("All fields are required", comment: ""), completion: { (done) in})
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func next(_ sender: UITextField)  {
        switch sender {
        case nameLabel:
            volumeLabel.becomeFirstResponder()
        case volumeLabel:
            wallsLabel.becomeFirstResponder()
        case wallsLabel:
            atticLabel.becomeFirstResponder()
        case atticLabel:
            groundStaffLabel.becomeFirstResponder()
        case groundStaffLabel:
            carpentryLabel.becomeFirstResponder()
        case carpentryLabel:
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
