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
    var technicians: [Technician] = []
    var clientID:String!
    
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
    @IBOutlet weak var alertSwitch: UISwitch!
    
    //MARK: view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.configureTableView()
        //get ecs, heating, photos and comments
        oneTo10Labels.names = ["0", "20", "40", "60", "80", "100"]
        oneTo10Slider.ticksListener = oneTo10Labels
        self.title = projectAddress.project.type
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 16)!]
        
        oneTo10Slider.addTarget(self,
                                 action: #selector(valueChanged(_:event:)),
                                 for: .valueChanged)
        
        self.reloadStatus()
        self.clientID = "\(self.projectAddress.project.client_id)"
        self.streetLabel?.text = self.projectAddress.project.clientName

    }
    
    func reloadStatus() {
        print()
        switch self.projectAddress.project.statut_technicien {
        case "fini":
            //if status is finished that means project has a 100% of proggress
            self.oneTo10Slider.value = 6.0
            self.alertSwitch.isOn = false
        case "prevu":
            let newButton = UIBarButtonItem(title: NSLocalizedString("Start", comment: ""), style: .done, target: self, action: #selector(setProjectAsStarted))
            self.navigationItem.rightBarButtonItem = newButton
            self.alertSwitch.isOn = false
        case "urgence":
            self.alertSwitch.isOn = true
        default:
            print("en cours")
            self.alertSwitch.isOn = false
            self.navigationItem.rightBarButtonItem = nil
        }
        
        guard let progress = self.projectAddress.project.progress else {
            return
        }
        
        switch progress {
        case "0":
            self.oneTo10Slider.value = 0
        case "20":
            self.oneTo10Slider.value = 1
        case "40":
            self.oneTo10Slider.value = 2
        case "60":
            self.oneTo10Slider.value = 3
        case "80":
            self.oneTo10Slider.value = 4
        case "100":
            self.oneTo10Slider.value = 5
        default: break
        }
    }

    func valueChanged(_ sender: TGPDiscreteSlider, event:UIEvent) {
        var status: (value: String, percentage:String)!
        switch Double(sender.value) {
        case 0.0:
            status = ("en cours", "0")
        case 1.0:
            status = ("en cours", "20")
        case 2.0:
            status = ("en cours", "40")
        case 3.0:
            status = ("en cours", "60")
        case 4.0:
            status = ("en cours", "80")
        case 5.0:
            status = ("fini", "100")
            //Save As Finished
        default: break
        }
        
        self.updateTechnianStatus(value: status.value, percetage: status.percentage)

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
            vc.authorString = "Technician"
        case "HistorySegue":
            let vc = segue.destination as! HistoryViewController
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
    
    @IBAction func showHistory(_ sender: Any) {
        self.performSegue(withIdentifier: "HistorySegue", sender: self)
    }
    
    
    
    //MARK: api updates
    
    
    func setProjectAsStarted() {
        //update project to set as started,
        //if the project if different of accepted or emtpy this action should not being showed
        if self.technicians.count > 0 {
            self.updateTechnianStatus(value: "en cours", percetage:"0")
        }else {
            ELVTAlert.showMessage(controller: self, message: NSLocalizedString("This project does not have any technicians assigned.", comment: ""), completion: { (done) in
                
            })
        }
        
    }
    
    @IBAction func setProjectAsUrgency(sender: UISwitch) {
        var string = "urgence"
        if sender.isOn {
            ELVTAlert.showConfirmationMessage(controller: self, message: NSLocalizedString("Set as urgency?", comment: "")) { (done) in
                if done == true {
                    ELVTAlert.showFormWithFields(controller: self, message: NSLocalizedString("Insert a comment", comment: ""), fields: ["Message"], completion: { (results) in
                        string = "urgence"
                    })
                } else {
                    sender.isOn = false
                }
            }
        } else {
            string = "en cours"
        }
        
        var status: (value: String, percentage:String)!
        switch Double(self.oneTo10Slider.value) {
        case 0.0:
            status = (string, "0")
        case 1.0:
            status = (string, "20")
        case 2.0:
            status = (string, "40")
        case 3.0:
            status = (string, "60")
        case 4.0:
            status = (string, "80")
        case 5.0:
            status = (string, "100")
        default:
            self.updateTechnianStatus(value: string, percetage: status.percentage)
        }
        self.updateTechnianStatus(value: string, percetage:  status.percentage)

    }
    
    func updateTechnianStatus(value: String, percetage: String) {
        DispatchQueue.main.async {
            APIRequests.projectStatus(project: self.projectAddress.project, statusTechnician:  value, percentage: percetage) {
                DispatchQueue.main.async {
                    self.projectAddress.project.statut_technicien = value
                    self.reloadStatus()
                }
            }
        }
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
                                
                                
                                self.addressLabel?.text = "\(self.projectAddress.address.numberString!), \(self.projectAddress.address.street)"
                                self.heatingLabel?.text = "\(self.networks.count) " + NSLocalizedString("Heating networks", comment: "")
                                self.ecsLabel.text = "\(self.ecsObjects.count) " + NSLocalizedString("ECS networks", comment: "")
                                self.photosLabel.text = "\(self.photos.count) " + "Photos"
                                self.nameLabel.text = "\(self.projectAddress.address.postalCode), \(self.projectAddress.address.city)"
                                //Project Details
                                APIRequests.importProjectDetails(chantierID: "\(self.projectAddress.project.chantier_id)") { (projectObject) in
                                    DispatchQueue.main.async {
                                    let projectObj = projectObject.0! as Project
                                        self.projectAddress.project = projectObj
                                        
                                        //technicians
                                        APIRequests.importTechnicians(statut: nil, chantierID: "\(self.projectAddress.project.chantier_id)") { (technicians) in
                                            self.technicians = technicians
                                            DispatchQueue.main.async {
                                                //STATUS
                                                if let duration = projectObj.duree_chantier {
                                                    if duration.isEmpty {
                                                        self.timeLabel.text = NSLocalizedString("No duration", comment: "")
                                                    } else {
                                                        let expectedDuration = NSLocalizedString("expected duration", comment: "")
                                                        self.timeLabel.text = "\(expectedDuration): \(duration) \(projectObj.unite_temps!)"
                                                    }
                                                } else {
                                                    self.timeLabel.text = NSLocalizedString("No duration", comment: "")
                                                }
                                                
                                                //TECHNICIANS
                                                var names = ""

                                                if self.technicians.count  > 0 {
                                                    for technician in self.technicians {
                                                        names = technician.name + ", " + names
                                                    }
                                                    //remove comma
                                                    for _ in  0...1 {
                                                        names =  names.substring(to: (names.index(before: (names.characters.endIndex))))
                                                    }
                                                    self.oneTo10Slider.isUserInteractionEnabled = true
                                                    self.oneTo10Labels.isUserInteractionEnabled = true
                                                }else{
                                                    names = NSLocalizedString("No Technicians selected", comment: "")
                                                    self.oneTo10Slider.isUserInteractionEnabled = false
                                                    self.oneTo10Labels.isUserInteractionEnabled = false
                                                    
                                                    ELVTAlert.showMessage(controller: self, message: NSLocalizedString("This project does not have any technicians assigned. You can't change proggess status, only Alert", comment: ""), completion: { (done) in })

                                                }
                                             self.timeLabel.text?.append("\n\(names)")
                                            }
                                        }
                                        
                                        print(projectObj)
                                        
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

extension ProjectUpdatesViewController {
    @IBAction func callContact() {
        //getting phone number from contact
        APIRequests.getClient(clientID: self.clientID) { (client) in
            DispatchQueue.main.async {
                print((client["client"] as! Client).cellPhone!)
                
                guard let phone = (client["client"] as! Client).cellPhone else {
                    ELVTAlert.showMessage(controller: self, message: NSLocalizedString("This client does not have a valid phone number", comment: ""), completion: { (done) in })
                    return
                }
                
                //calling...
                if let url = URL(string: "telprompt://\(phone)") {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

