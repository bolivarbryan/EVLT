//
//  CommercialProjectDetailsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class CommercialProjectDetailsViewController: UIViewController, NewProjectDelegate {
    var project: Project!
    var client: Client!
    var currentPlace: Place!
    var zones:[Zone]!
    var networks: [Network]!
    var ecsObjects: [ECS] = []
    
    //Contact information
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //Technical Survey
    @IBOutlet weak var zonesLabel: UILabel!
    @IBOutlet weak var heatingLabel: UILabel!
    @IBOutlet weak var ecsLabel: UILabel!
    
    //News
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    //Installation
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var technicianLabel: UILabel!
    
    //Status
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Project: \(project.type)")
      
        let newButton = UIBarButtonItem(title: NSLocalizedString("Edit", comment: ""), style: .done, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = newButton
    
    }
    
    func edit() {
        self.performSegue(withIdentifier: "EditProjectSegue", sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchProjectDetails(completion: @escaping (_ completion: Project?) -> Void) {
        
        //Project Details
        APIRequests.importProjectDetails(chantierID: "\(self.project.chantier_id)") { (projectObject) in
            print(projectObject.0! as Project)
            print(projectObject.1! as Place)
            self.project = projectObject.0! as Project
            if let place = projectObject.1 {
                self.currentPlace = place
                completion(nil)
            }
        }
        
        //Zones Project
        APIRequests.zonesProject(projectID: "\(self.project.chantier_id)") { (zones) in
            print(zones)
            self.zones = zones
            DispatchQueue.main.async {
                self.zonesLabel.text = "\(self.zones.count) " + NSLocalizedString("Zone", comment: "")
                if self.zones.count != 1 {
                    self.zonesLabel.text?.append("s")
                }
            }
        }
        
        //Heating network
        APIRequests.getHeatingNetwork(type: "chauffage", projectID: "\(self.project.chantier_id)") { (response) in
            DispatchQueue.main.async {
                self.networks = response
                self.heatingLabel.text = "\(self.networks.count) " + NSLocalizedString("Heating Network", comment: "")
                if self.networks.count != 1 {
                    self.heatingLabel.text?.append("s")
                }
            }
        }
        
        //ECS
        APIRequests.getECS(type: "ECS", projectID: "\(self.project.chantier_id)") { (response) in
            DispatchQueue.main.async {
                self.ecsObjects = response
                self.ecsLabel.text = "\(self.ecsObjects.count) " + NSLocalizedString("No ECS Networks", comment: "")
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProjectDetails { (projectObject) in
            DispatchQueue.main.async {
                self.streetLabel.text = "\(self.currentPlace.number), \(self.currentPlace.street)"
                self.addressLabel.text = "\(self.currentPlace.postalCode), \(self.currentPlace.city)"
                self.nameLabel.text = "\(self.client.fullName())"
                if let p = self.project {
                    if p.duree_chantier != "" {
                        let date = EVLTDateFormatter.stringFromDate(date: p.date_contact)
                        self.dateLabel.text = "\(p.duree_chantier!) \(p.unite_temps!), \(date)"
                    }
                    self.commentsLabel.text = p.comments!
                }
              
             }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "AddressSegue":
                let vc = segue.destination as! CommercialContactInformationViewController
                vc.place = currentPlace
                vc.project = self.project
            case "ZonesSegue":
                let vc = segue.destination as! ZonesViewController
                vc.zones = self.zones
                vc.project = self.project
            case "HeatingSegue":
                let vc = segue.destination as! HeatingNetworkListViewController
                vc.networks = self.networks
                vc.project = self.project
            case "EditProjectSegue":
                let vc = segue.destination as! NewProjectViewController
                vc.project = self.project
                vc.client = self.client
                vc.delegate = self
            case "ECSSegue":
                let vc = segue.destination as! CommercialNoECSListViewController
                vc.project = self.project
            case "DateSegue":
                let vc = segue.destination as! DateViewController
                vc.project = self.project
            case "CommentsSegue":
                let vc = segue.destination as! TechnicianCommentsViewController
                vc.project = self.project

            default:
                print("no selection")
            }
        }
     
    }
    
    //Delegates for new project
    func projectCanceled() {
        
    }
    
    func projectSuccessfullyCreated() {
        
    }
}
