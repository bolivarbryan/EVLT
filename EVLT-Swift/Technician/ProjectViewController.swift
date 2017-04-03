//
//  ProjectViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: PROPERTIES
    var projectAddressArray: [(project: Project, address: Place)] = []
    var selectedProjectAddress: (project: Project, address: Place)!
    var parentVC: UIViewController? = nil
    var hasParentVC: Bool {
        get {
            if let _ = self.parentVC {
                return true
            } else {
                return false
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.title = NSLocalizedString("Projects", comment: "")
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ProjectUpdatesViewController
            vc.projectAddress = selectedProjectAddress
        }
    }
    
    //MARK: TABLEVIEW

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCellTableViewCell
        cell.nameLabel?.text = projectAddressArray[indexPath.row].project.clientName
        
        if hasParentVC == true {
            cell.subtitleLabel?.text = "\(projectAddressArray[indexPath.row].address.formattedAddress())"
        }else {
            cell.subtitleLabel?.text = "\(projectAddressArray[indexPath.row].project.type) - \(projectAddressArray[indexPath.row].project.statut_technicien)"
        }
        
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectAddressArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if hasParentVC == false {
            tableView.deselectRow(at: indexPath, animated: true)
            self.selectedProjectAddress = projectAddressArray[indexPath.row]
            self.performSegue(withIdentifier: "segue", sender: self)
        //}
    }
}
