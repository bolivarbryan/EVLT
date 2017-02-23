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
  
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: String = NSLocalizedString("Name", comment: "")
    var existant: Bool = false
    var material: String = ""
    var diametre: String = "Insérer un diametre"
    let materials = [(name: NSLocalizedString("Copper", comment: ""), values:["10","12","14","15","16","18","20","22","18","32","35"] ), (name:"PER", values: ["16","20","25"]), (name:NSLocalizedString("Steel", comment: ""), values: ["12 x 17","15 x 21","20 x 27","26 x 34","33 x 42","40 x 49", "50 x 60"])]
    
    let kCellIdentifier = "cellIdentifier"
    var selectedIndexPath:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Network", comment: "")
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton

        if let n = self.network {
            self.material = n.material
            self.diametre = n.diameter
            self.name = n.name!
            self.existant = (n.existing  == "existant")
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func new() {
        
        //SAVE ECS
        if material == "" {
            material = "N/A"
        }
        
        if diametre == "Insérer un diametre" {
            diametre = "NC"
        }
        
        var existantString = "existant"
        if existant == false {
            existantString = "a creer"
        }
        
        if name == "" {
            name = "N/A"
        }
        
        var action = kActionTypeNew
        
        var netWorkObject = Network(existing: existantString, radiators: "N/A", material:material, diameter: diametre)
        netWorkObject.name = name
        
        if let e = network {
            action = kActionTypeUpdate
            netWorkObject.projectId = network?.projectId
            netWorkObject.netWorkId = network?.netWorkId
        }
        
        APIRequests.createNetwork(action: action, projectID: "\(self.project.chantier_id)", network: netWorkObject, completion: { (n) in
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        })

    }
}



extension HeatingNetworkDetailsViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Nom"
        case 1:
            return "Existant?"
        case 2:
            return "Choisir le matériel"
        case 3:
            return "Diametre"
        default:
            return ""
        }
    }
    
    func toggleExistant() {
        existant = !existant
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //insert a name
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = name
            cell.textLabel?.textColor = UIColor.gray
            return cell
        case 1:
            //existant
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.fieldNameLabel.text = NSLocalizedString("Existant?", comment: "")
            cell.fieldNameLabel?.textColor = UIColor.gray
            
            cell.switchField.isOn = self.existant
            
            cell.switchField.addTarget(self, action: #selector(toggleExistant), for: .valueChanged)
            
            return cell
            
        case 2:
            //material
            //insert a name
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = self.materials[indexPath.row].name
            cell.textLabel?.textColor = UIColor.gray
            
            if selectedIndexPath == nil {
                if self.materials[indexPath.row].name == material {
                    self.selectedIndexPath = indexPath
                }
            }
            
            if indexPath == selectedIndexPath {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
            
            return cell
            
        case 3:
            //diametre
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = diametre
            cell.textLabel?.textColor = UIColor.gray
            
            return cell
        default:
            //this never should be called
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            return cell
        }
        
        
    }
}

extension HeatingNetworkDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            ELVTAlert.showFormWithFields(controller: self, message: "Insérer un nom", fields: ["Nom"], completion: { (strings) in
                if let s = strings.last {
                    self.name = s
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [indexPath], with: .fade)
                    }
                }
            })
        case 2:
            self.material = self.materials[indexPath.row].name
            self.selectedIndexPath = indexPath
            DispatchQueue.main.async {
                self.diametre = self.materials[(self.selectedIndexPath?.row)!].values[0]
                self.tableView.reloadData()
            }
        case 3:
            if self.selectedIndexPath != nil {
                EVLTPicker.sharedInstance.showPicker(inController: self, withMessage: "Insérer un diametre", values: self.materials[(self.selectedIndexPath?.row)!].values)
                EVLTPicker.sharedInstance.evltPickerDelegate = self
            }
        default: break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension HeatingNetworkDetailsViewController: EvltPickerDelegate {
    func pickerDismissed(index: Int?) {
        self.diametre = self.materials[(self.selectedIndexPath?.row)!].values[index!]
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [self.selectedIndexPath!], with: .fade)
        }
        self.tableView.reloadData()
    }
}
