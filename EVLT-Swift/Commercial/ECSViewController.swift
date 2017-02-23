//
//  ECSViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 2/21/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class ECSViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var name: String = NSLocalizedString("Name", comment: "")
    var existant: Bool = false
    var material: String = ""
    var diametre: String = "Insérer un diametre"
    let materials = [(name: NSLocalizedString("Copper", comment: ""), values:["10","12","14","15","16","18","20","22","18","32","35"] ), (name:"PER", values: ["16","20","25"]), (name:NSLocalizedString("Steel", comment: ""), values: ["12 x 17","15 x 21","20 x 27","26 x 34","33 x 42","40 x 49", "50 x 60"])]
    
    let kCellIdentifier = "cellIdentifier"    
    var selectedIndexPath:IndexPath? = nil
    var project: Project!
    var ecs: ECS? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
        //came for edit?
        if let e = ecs {
            name = e.name
            existant = e.existant == "existant"
            material = e.material
            diametre = e.diameter
            self.tableView.reloadData()
        }
       
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
        
        if let e = ecs {
            action = kActionTypeUpdate
        }
        
        var ecsObject = ECS(name: name, existant: existantString, diameter: diametre, material: material)
        ecsObject.radiateur = "N/A"
        
        APIRequests.projectNetwork(ecs: ecsObject, action: action, chantierID: "\(self.project.chantier_id)") {
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ECSViewController: UITableViewDataSource{
    
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

extension ECSViewController: UITableViewDelegate {
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

//TODO: Move SwitchCell to its own File
class SwitchCell: UITableViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var switchField: UISwitch!
}

extension ECSViewController: EvltPickerDelegate {
    func pickerDismissed(index: Int?) {
        self.diametre = self.materials[(self.selectedIndexPath?.row)!].values[index!]
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [self.selectedIndexPath!], with: .fade)
        }
        self.tableView.reloadData()
    }
}
