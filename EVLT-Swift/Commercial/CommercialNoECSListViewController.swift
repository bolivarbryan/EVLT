//
//  CommercialNoECSListViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 2/21/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class CommercialNoECSListViewController: UIViewController {

    var ecs: ECS? = nil
    var ecsObjects: [ECS]! = []
    var project: Project!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIBarButtonItem(title: NSLocalizedString("New", comment: ""), style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    func new() {
        self.performSegue(withIdentifier: "NewECSSegue", sender: self)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewECSSegue"{
        let vc = segue.destination as! ECSViewController
            vc.project = self.project
            vc.ecs = self.ecs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIRequests.getECS(type: "ECS", projectID: "\(self.project.chantier_id)") { (response) in
            DispatchQueue.main.async {
                self.ecsObjects = response
                self.tableView.reloadData()
            }
        }
    }

}


extension CommercialNoECSListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AnexeCellID") as! ESCCell
        
        cell.diameterLabel.text = ecsObjects[indexPath.row].name
        cell.materialLabel.text = ecsObjects[indexPath.row].material
        cell.diameterLabel.text = ecsObjects[indexPath.row].diameter
        cell.namelabel.text = ecsObjects[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ecsObjects.count
    }
    
}

extension CommercialNoECSListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //details
        tableView.deselectRow(at: indexPath, animated: true)
        self.ecs = ecsObjects[indexPath.row]
        self.performSegue(withIdentifier: "NewECSSegue", sender: self)
    }
}


class ESCCell: UITableViewCell {
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var existantLabel: UILabel!
    @IBOutlet weak var materialLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
}

//TODO: separate model in other file
struct ECS {
    var name: String
    var existant: String
    var diameter: String
    var material: String
    var radiateur: String = "N/A"
    var ecsID: String? = nil
    var type:String = "ECS"
    
    init(name:String, existant: String, diameter: String, material: String) {
        self.name = name
        self.existant = existant
        self.diameter = diameter
        self.material = material
    }
}
