//
//  CommercialProjectsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class CommercialProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        
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
    let totalCells = 5
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < totalCells - 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
            
            return cell
        }else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SubmitCell", for: indexPath)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalCells
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < totalCells - 1 {
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }

}
