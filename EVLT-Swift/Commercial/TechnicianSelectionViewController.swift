//
//  TechnicianSelectionViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
import SDWebImage

class TechnicianSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var project: Project!
    var technicians = [Technician]()
    var selectedTechnicians = [Technician]()
    let itemSize = CGSize(width: 30, height: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        //let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        //self.navigationItem.rightBarButtonItem = newButton
        fillData()
        self.tableView.reloadData()
    }
    
    func fillData() {
        APIRequests.importTechnicians(statut:"OUVRE", chantierID: "") { (technicianObjects) in
            DispatchQueue.main.async {
                self.technicians = technicianObjects
                self.tableView.reloadData()
            }
        }
    }
    
    func new() {
//        func getSelectedTechnicians() -> [(name: String, selected: Bool)]{
//            let found = technicians.filter({$0.selected == true})
//            print(found)
//            return found
//        }
//        
//        _ =  getSelectedTechnicians()
//        
        //saving to api
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension Array {
    func containsObject<T>(obj: T) -> Bool where T : Equatable, T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

//MARK: Tableview Protocols
extension TechnicianSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return technicians.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "identifier"
        //var cell = tableView.dequeueReusableCell(withIdentifier: "")  as CellClass
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier )
        cell.textLabel?.text = technicians[indexPath.row].name + " " + technicians[indexPath.row].lastName
        cell.accessoryType = .none
        
        for st in selectedTechnicians {
            if (st.name + st.lastName) == (technicians[indexPath.row].name + technicians[indexPath.row].lastName) {
                cell.accessoryType = .checkmark
            }
        }
        
       
    
        cell.imageView?.sd_setImage(with: URL(string: technicians[indexPath.row].pictureUrl), placeholderImage: UIImage())
        //change for technician picture
        UIGraphicsBeginImageContextWithOptions(self.itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect(x: 0, y: 0, width: self.itemSize.width, height: self.itemSize.height)
        UIBezierPath(roundedRect: imageRect, cornerRadius: 15).addClip()
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return cell
    }
   
}

extension TechnicianSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var index = 0
        var found = false
        for st in selectedTechnicians {
            
            let tecnicianName = st.name + st.lastName
            let technicianName2 = technicians[indexPath.row].name + technicians[indexPath.row].lastName
            
            if tecnicianName == technicianName2 {
                if (tableView.cellForRow(at: indexPath)?.accessoryType)!  == .checkmark {
                    //already selected, remove from array
                    self.selectedTechnicians.remove(at: index)
                    found = true
                    //delete technician
                    APIRequests.saveTechnicians(statut:"DELETE",techicianID: technicians[indexPath.row].id , chantierID: "\(self.project.chantier_id)") { (technicianObjects) in }
                    break
                }
            }
            index = index + 1
        }
        
        if found == false {
            selectedTechnicians.append(technicians[indexPath.row])
            //save technician
            APIRequests.saveTechnicians(statut:"SAVE",techicianID: technicians[indexPath.row].id , chantierID: "\(self.project.chantier_id)") { (technicianObjects) in }
            
        }
        //technicians[indexPath.row].selected = !technicians[indexPath.row].selected
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
