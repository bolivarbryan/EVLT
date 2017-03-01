//
//  CommercialProjectsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class CommercialProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var client: Client!
    var chantiers: [Dictionary<String, Any>] = []
    var selectedProject: Project? = nil
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CommercialProjectsViewController.reload), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.tableView.backgroundView = self.refreshControl
        reload()
        //TODO: translate "Edit Client"
        let done = UIBarButtonItem(title: NSLocalizedString("Edit Client", comment: ""), style: .done, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = done
        
    }
    func edit() {
        self.performSegue(withIdentifier: "EditClientSegue", sender: self)
        
    }

    func reload() {
        APIRequests.importProjectWithClientID(clientID: client.clientID) { (results) in
            self.chantiers = results
            DispatchQueue.main.async {
                print(self.chantiers.count)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableview
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= chantiers.count - 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCellTableViewCell
            cell.nameLabel.text = chantiers[indexPath.row]["type"] as? String
            cell.subtitleLabel.text =  "Status: \(chantiers[indexPath.row]["statut"]!)"

            return cell
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SubmitCell", for: indexPath)
            
            return cell
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "projectsSegue" {
            if let vc = (segue.destination as! UINavigationController).childViewControllers[0] as? NewProjectViewController {
                vc.client = self.client
                vc.delegate = self
            }
        }else if segue.identifier == "segue" {
            let vc = segue.destination as! CommercialProjectDetailsViewController
            vc.project = self.selectedProject
            vc.client = self.client
        }else if segue.identifier == "EditClientSegue" {
            let vc = segue.destination as! NewClientViewController
            vc.selectedClient = self.client
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chantiers.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == chantiers.count  {
            self.performSegue(withIdentifier: "projectsSegue", sender: self)
        }else{
            let chantier = self.chantiers[indexPath.row]
            //FIXME: get real values
            let project = Project(tva: 0, prix_ttc: .notAvailable, type: chantier["type"] as! String, date_contact: Date(), statut_technicien: "", client_id: Int(self.client.clientID)!, contact: "", status: .visitFait, chantier_id: Int(chantier["chantier_id"] as! String)!, statut_administratif: .toBeProggramed, prix_ht: 0)
            self.selectedProject = project
            
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            let type = self.chantiers[indexPath.row]["type"] as! String
            ELVTAlert.showConfirmationMessage(controller: self, message: NSLocalizedString("Are you you sure you want to delete " + type, comment: ""), completion: { (done) in
                if done == true {
                    //api call to delete
                    let query = "DELETE FROM `envertlaevlt`.`chantier` WHERE `chantier`.`chantier_id` = \(self.chantiers[indexPath.row]["chantier_id"]!)"
                    APIRequests.deleteRecord(query: query , completion: { (done) in
                        self.reload()
                    })
                }
            })
        }
        
        delete.backgroundColor = .red
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension CommercialProjectsViewController: NewProjectDelegate {
    func projectSuccessfullyCreated() {
        APIRequests.importProjectWithClientID(clientID: client.clientID) { (results) in
            self.chantiers = results
            DispatchQueue.main.async {
                print(self.chantiers.count)
                self.tableView.reloadData()
                let chantier = self.chantiers[self.chantiers.count - 1]
                let project = Project(tva: 0, prix_ttc: .notAvailable, type: chantier["type"] as! String, date_contact: Date(), statut_technicien: "", client_id: Int(self.client.clientID)!, contact: "", status: .visitFait, chantier_id: Int(chantier["chantier_id"] as! String)!, statut_administratif: .toBeProggramed, prix_ht: 0)
                self.selectedProject = project
                self.performSegue(withIdentifier: "segue", sender: self)
            }
        }
    }
    
    func projectCanceled() {
       
    }
}
