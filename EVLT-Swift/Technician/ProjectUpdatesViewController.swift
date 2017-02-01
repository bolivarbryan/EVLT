//
//  ProjectUpdatesViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class ProjectUpdatesViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        // Do any additional setup after loading the view.
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
    
    let cells = ["ProjectUpdateCellAboutID", "RerservationCellID", "RerservationCellID", "RerservationCellID", "AdvancementCellID"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "heatingSegue", sender: self)
        case 2:
            self.performSegue(withIdentifier: "ecsSegue", sender: self)
        case 3:
            self.performSegue(withIdentifier: "commentsSegue", sender: self)
        default:
            print("invalid option")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cells[indexPath.row] {
        case "AdvancementCellID":
            return 162
        case "RerservationCellID":
            return 100
        case "ProjectUpdateCellAboutID":
            return 97
        default:
            return 97
        }
    }

}
