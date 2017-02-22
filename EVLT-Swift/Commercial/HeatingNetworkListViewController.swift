//
//  HeatingNetworkListViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 19/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class HeatingNetworkListViewController: UIViewController {
    var project: Project!
    var selectedNetwork: Network? = nil
    var networks: [Network]! = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let newButton = UIBarButtonItem(title: NSLocalizedString("New", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func new() {
        self.selectedNetwork = nil
        self.performSegue(withIdentifier: "NewNetWorkSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchData() {
        APIRequests.getHeatingNetwork(type: "chauffage", projectID: "\(self.project.chantier_id)") { (response) in
            DispatchQueue.main.async {
                self.networks = response
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewNetWorkSegue" {
            let vc = segue.destination as! HeatingNetworkDetailsViewController
            vc.project = self.project
            vc.network = self.selectedNetwork
        }
    }
}

extension HeatingNetworkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnexeCellID") as! AnexeCell
        cell.name.text = networks[indexPath.row].name
        cell.existant.text = "Existant: " + networks[indexPath.row].existing
        cell.material.text = "Material: " + networks[indexPath.row].material
        cell.diameter.text = "Diameter: " + networks[indexPath.row].diameter
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}

extension HeatingNetworkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedNetwork = networks[indexPath.row]
        self.performSegue(withIdentifier: "NewNetWorkSegue", sender: self)
    }
}

class AnexeCell: UITableViewCell {
    @IBOutlet weak var diameter: UILabel!
    @IBOutlet weak var material: UILabel!
    @IBOutlet weak var existant: UILabel!
    @IBOutlet weak var name: UILabel!
}
