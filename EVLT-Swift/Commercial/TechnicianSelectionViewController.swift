//
//  TechnicianSelectionViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class TechnicianSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var technicians: [(name: String, selected: Bool)] = []
    let itemSize = CGSize(width: 30, height: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        fillData()
        self.tableView.reloadData()
    }
    
    func fillData() {
        technicians.append((name:"Denis", selected: false))
        technicians.append((name:"Fred", selected: false))
        technicians.append((name:"James", selected: false))
        technicians.append((name:"Emmanuel", selected: false))
        technicians.append((name:"Reynald", selected: false))
    }
    
    func new() {
        func getSelectedTechnicians() -> [(name: String, selected: Bool)]{
            let found = technicians.filter({$0.selected == true})
            print(found)
            return found
        }
        
        _ =  getSelectedTechnicians()
        
        //saving to api
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.textLabel?.text = technicians[indexPath.row].name
        cell.detailTextLabel?.text = " d"
        if technicians[indexPath.row].selected == true {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        //change for technician picture
        cell.imageView?.image = #imageLiteral(resourceName: "logo_technicien")
        
        //Code for modify default cell image, if ui is more complex create a custom uitableviewcell
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
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
        technicians[indexPath.row].selected = !technicians[indexPath.row].selected
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
