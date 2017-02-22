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
    var diametre: String = "Insert a diameter"
    let materials = [NSLocalizedString("Copper", comment: ""), "PER", NSLocalizedString("Steel", comment: "")]
    
    let kCellIdentifier = "cellIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
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
            return "Material"
        case 3:
            return "Diametre"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //insert a name
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = name
            return cell
        case 1:
            //existant
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.fieldNameLabel.text = NSLocalizedString("Existant?", comment: "")
            
            cell.switchField.isOn = self.existant
            return cell
            
        case 2:
            //material
            //insert a name
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = self.materials[indexPath.row]
            return cell
            
        case 3:
            //diametre
            let cell = UITableViewCell(style: .default, reuseIdentifier: kCellIdentifier)
            cell.textLabel?.text = diametre
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
        //TODO: use actionpicker for fill form and reload tableview
        
    }
}

class FormTableViewCell: UITableViewCell {
    
}

class SwitchCell: UITableViewCell {
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var switchField: UISwitch!
    
}
