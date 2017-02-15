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
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chantiers.count + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == chantiers.count  {
            self.performSegue(withIdentifier: "projectsSegue", sender: self)
        }else{
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }

}
