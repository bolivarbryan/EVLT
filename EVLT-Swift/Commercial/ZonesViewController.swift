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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newButton = UIBarButtonItem(title: kNewZone, style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    func new() {
        self.performSegue(withIdentifier: "NewSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func fetchData()  {
        
        //api request
        
        //parse data
        
        DispatchQueue.main.async {
            self.zones = []
            self.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZonesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZonesCell") as! ZonesCell
        cell.name.text = zones[indexPath.row].name
        cell.volumeLabel.text = zones[indexPath.row].volume
        cell.wallLabel.text = zones[indexPath.row].walls
        cell.loftLabel.text = zones[indexPath.row].attic
        cell.rampantsLabel.text = zones[indexPath.row].groundStaff
        cell.woodworkLabel.text = zones[indexPath.row].carpentry
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
}

extension ZonesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
