//
//  AdministrativeProgrammingViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class AdministrativeProgrammingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var projectAddressArray: [(project: Project, address: Place)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.title = NSLocalizedString("Projects to be proggrammed", comment: "")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 135
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: tableview
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! AdministrativeTableViewCell
        let p = projectAddressArray[indexPath.row].project
        let a = projectAddressArray[indexPath.row].address
        
        cell.projectTextField?.text = "\(p.clientName!) - \(p.type)"

        if p.duree_chantier != nil {
            cell.addressTimeLabel?.text = "\(a.formattedAddress()) - \(p.duree_chantier!) \(String(describing: p.unite_temps))"

        }else {
            cell.addressTimeLabel?.text = a.formattedAddress()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectAddressArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

class AdministrativeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectTextField: UILabel!
    @IBOutlet weak var clientButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    @IBOutlet weak var addressTimeLabel: UILabel!
    
}
