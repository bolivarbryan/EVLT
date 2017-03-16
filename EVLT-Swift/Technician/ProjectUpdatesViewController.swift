//
//  ProjectUpdatesViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit
import TGPControls

class ProjectUpdatesViewController:  UIViewController {
    //MARK: PROPERTIES
    var projectAddress: (project: Project, address: Place)!
    var networks = [Network]()
    var ecsObjects = [ECS]()
    var photos = [Photo]()
    @IBOutlet weak var oneTo10Labels: TGPCamelLabels!
    @IBOutlet weak var oneTo10Slider: TGPDiscreteSlider!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heatingLabel: UILabel!
    @IBOutlet weak var ecsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.configureTableView()
        //get ecs, heating, photos and comments
        oneTo10Labels.names = ["0", "20", "40", "60", "80", "100"]
        oneTo10Slider.ticksListener = oneTo10Labels
        self.title = projectAddress.project.type
        

        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 16)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProjectDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 17)!]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchProjectDetails() {
        //Heating network
        APIRequests.getHeatingNetwork(type: "chauffage", projectID: "\(self.projectAddress.project.chantier_id)") { (response) in
            DispatchQueue.main.async {
                self.networks = response
                //ECS
                APIRequests.getECS(type: "ECS", projectID: "\(self.projectAddress.project.chantier_id)") { (response) in
                    DispatchQueue.main.async {
                        self.ecsObjects = response
                        //photos
                        APIRequests.listPhotos(projectID: "\(self.projectAddress.project.chantier_id)") { (photoObjects) in
                            self.photos = photoObjects
                              DispatchQueue.main.async {
                                //self.tableView.reloadData()
                                self.streetLabel?.text = self.projectAddress.project.clientName
                                self.addressLabel?.text = "\(self.projectAddress.address.numberString!), \(self.projectAddress.address.street)"
                                self.heatingLabel?.text = "\(self.networks.count) " + NSLocalizedString("Heating networks", comment: "")
                                self.ecsLabel.text = "\(self.ecsObjects.count) " + NSLocalizedString("ECS networks", comment: "")
                                self.photosLabel.text = "\(self.photos.count) " + "Photos"
                                self.nameLabel.text = "\(self.projectAddress.address.postalCode), \(self.projectAddress.address.city)"
                                //Project Details
                                APIRequests.importProjectDetails(chantierID: "\(self.projectAddress.project.chantier_id)") { (projectObject) in
                                    DispatchQueue.main.async {
                                    let projectObj = projectObject.0! as Project
                                        print(projectObj)
                                        if let duration = projectObj.duree_chantier {
                                            if duration.isEmpty {
                                                self.timeLabel.text = NSLocalizedString("No duration", comment: "")
                                            }else{
                                                let expectedDuration = NSLocalizedString("expected duration", comment: "")
                                             self.timeLabel.text = "\(expectedDuration): \(duration) \(projectObj.unite_temps!)"
                                            }
                                        } else {
                                            self.timeLabel.text = NSLocalizedString("No duration", comment: "")
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "heatingSegue":
            let vc = segue.destination as! HeatingNetworkListViewController
            vc.project = self.projectAddress.project
            vc.isTechincianParentController = true
        case "photosSegue":
            let vc = segue.destination as! PhotosViewController
            vc.project = self.projectAddress.project
            vc.isTechincianParentController = true
        case "ecsSegue":
            let vc = segue.destination as! CommercialNoECSListViewController
            vc.project = self.projectAddress.project
            vc.isTechincianParentController = true
        case "photosSegue":
            let vc = segue.destination as! PhotosViewController
            vc.project = self.projectAddress.project
            vc.isTechincianParentController = true
        case "commentsSegue":
            let vc = segue.destination as! TechnicianCommentsViewController
            vc.project = self.projectAddress.project
        default:
            print("no segue")
        }
    }
    
    @IBAction func showHeatingNetworks(_ sender: Any) {
        self.performSegue(withIdentifier: "heatingSegue", sender: self)
    }
    
    @IBAction func showECSNetworks(_ sender: Any) {
        self.performSegue(withIdentifier: "ecsSegue", sender: self)
    }

    @IBAction func showPhotos(_ sender: Any) {
        self.performSegue(withIdentifier: "photosSegue", sender: self)
    }

    @IBAction func showComments(_ sender: Any) {
        self.performSegue(withIdentifier: "commentsSegue", sender: self)
    }
    
    @IBAction func showNavigationMap(_ sender: Any) {
        let vc = MapRouteViewController()
        vc.address = self.projectAddress.address
        vc.project = self.projectAddress.project
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

