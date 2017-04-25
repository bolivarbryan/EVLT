//
//  AdministrativeTotalExigibleByCustomerViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 4/23/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class AdministrativeTotalExigibleByCustomerViewController: UIViewController {
    var payments = [ComposedPayment]()
    var totalByCustomer = [(clientName: String, total: Float)]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Total exigible by customer", comment: "")
        
        //TODO: Use swift 3 array sorting logic
        
        var ps2 = [ComposedPayment]()
        
        for p in payments {
            if ps2.contains(where: { p2 in return p2 == p }){
                //nothing from now
                let index = ps2.index(of: p)
                ps2[index!].totalExigible += p.totalExigible
            } else {
                ps2.append(p)
            }
        }
        

        let array = ps2.map({ p in
            return (clientName: p.client.fullName(), total: p.totalExigible)
        })
        
 
        self.totalByCustomer = array
        self.tableView.reloadData()
        
        
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}


//MARK: Tableview Protocols
extension AdministrativeTotalExigibleByCustomerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalByCustomer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "CustomerCellID"
        //var cell = tableView.dequeueReusableCell(withIdentifier: "")  as CellClass
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier )
        cell.textLabel?.text = totalByCustomer[indexPath.row].clientName
        cell.detailTextLabel?.text = "Total Exigible: \(totalByCustomer[indexPath.row].total) €"
        cell.detailTextLabel?.textColor = UIColor.gray
        
        return cell
    }
}

extension AdministrativeTotalExigibleByCustomerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
