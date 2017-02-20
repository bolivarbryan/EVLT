//
//  ZonesViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class ZonesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var zones: [Zone]!
    var project: Project!
    var selectedZone: Zone? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIBarButtonItem(title: kNewZone, style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    func new() {
        self.selectedZone = nil
        self.performSegue(withIdentifier: "NewSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func fetchData()  {
        
        //api request
        
        APIRequests.zonesProject(projectID: "\(self.project.chantier_id)") { (zones) in
            print(zones)
            self.zones = zones
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
      
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NewSegue" {
            let vc = segue.destination as! ZoneDetailsViewController
            vc.project = self.project
            vc.zone = self.selectedZone
        }
    }
 

}

extension ZonesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZonesCell") as! ZonesCell
        cell.name.text = zones[indexPath.row].name
        cell.volumeLabel.text = "Volume: " + zones[indexPath.row].volume
        cell.wallLabel.text = "Murs: " +  zones[indexPath.row].walls
        cell.loftLabel.text = "Combles: " +  zones[indexPath.row].attic
        cell.rampantsLabel.text = "Rampants:" + zones[indexPath.row].groundStaff
        cell.woodworkLabel.text = "Menuiseries: " + zones[indexPath.row].carpentry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
}

extension ZonesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedZone = zones[indexPath.row]
        self.performSegue(withIdentifier: "NewSegue", sender: self)
    }
}

class ZonesCell: UITableViewCell
{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var wallLabel: UILabel!
    @IBOutlet weak var loftLabel: UILabel!
    @IBOutlet weak var rampantsLabel: UILabel!
    @IBOutlet weak var woodworkLabel: UILabel!
}
