//
//  StatusViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 2/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    var project:Project!
    var status:ProjectStatus!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.status = self.project.status
        
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(rightAction))
        
        self.navigationItem.rightBarButtonItem = newButton
    }
   
    func rightAction() {
        APIRequests.projectStatus(project: self.project, statusTechnician:  "prevú", percentage: "0") {
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectValidationSegue" {
            let vc = segue.destination as! ProjectValidationViewController
            vc.project = self.project
            vc.delegate = self
        }
    }
}

//MARK: Tableview Protocols
extension StatusViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProjectStatus.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "StatusViewControllerIdentifier"
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier )

        cell.textLabel?.text = ProjectStatus.allValues[indexPath.row].detailed()
        cell.accessoryType = (cell.textLabel!.text == self.status.detailed()) ? .checkmark : .none
        
        return cell
    }
}

extension StatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.status = ProjectStatus.allValues[indexPath.row]
        tableView.reloadData()
        if indexPath.row == ProjectStatus.accepted.hashValue {
            self.performSegue(withIdentifier: "ProjectValidationSegue", sender: self)
        }else {
            self.project.status = ProjectStatus.allValues[indexPath.row]
            self.project.statut_technicien = TechnicianStatus.allValues[indexPath.row].rawValue
            self.project.statut_administratif = .unspecified
        }
    }
}

extension StatusViewController: ProjectValidationDelegate {
    func didValidate(total totalValue: Float, tax: Float) {
        self.project.status = .accepted
        self.project.prix_ht = totalValue
        self.project.tva = tax
        self.project.statut_administratif = .toBeProggramed
        self.tableView.reloadData()
    }
}
