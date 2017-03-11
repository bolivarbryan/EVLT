//
//  ProjectUpdatesViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit
import TGPControls

class ProjectUpdatesViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.configureTableView()
        fetchProjectDetails()
        //get ecs, heating, photos and comments
        oneTo10Labels.names = ["0", "20", "40", "60", "80", "100"]
        oneTo10Slider.ticksListener = oneTo10Labels

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchProjectDetails() {
        //Heating network
        print(self.projectAddress.project.chantier_id)
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
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: tableview
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    let cells = ["ProjectUpdateCellAboutID", "RerservationCellID", "RerservationCellID", "RerservationCellID", "RerservationCellID", "AdvancementCellID"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case "ProjectUpdateCellAboutID":
            let cell =  tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath) as! TechnicianClientCell
            cell.nameLabel?.text = self.projectAddress.project.type
            cell.addressLabel?.text = self.projectAddress.address.formattedAddress()
            return cell
        case "RerservationCellID":
            let cell =  tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath) as! TechnicianReservationCell
            
            switch indexPath.row {
            case 1:
                cell.reservationImage?.image = #imageLiteral(resourceName: "radiateur")
                cell.reservationLabel?.text = NSLocalizedString("Heating networks", comment: "")
                cell.detailsLabel?.text = "\(self.networks.count)"
            case 2:
                cell.reservationImage?.image = #imageLiteral(resourceName: "robinet")
                cell.reservationLabel?.text = NSLocalizedString("ECS networks", comment: "")
                cell.detailsLabel?.text = "\(self.ecsObjects.count)"
            case 3:
                cell.reservationImage?.image = #imageLiteral(resourceName: "commentaire")
                cell.reservationLabel?.text = NSLocalizedString("Comments", comment: "")
            case 4:
                cell.reservationImage?.image = #imageLiteral(resourceName: "photos")
                cell.reservationLabel?.text = NSLocalizedString("Photos", comment: "")
                cell.detailsLabel?.text = "\(self.photos.count)"
            default:
                print("invalid option")
            }
            
            return cell
        case "AdvancementCellID":
            let cell =  tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath) as! TechnicianAdvancementCell
            return cell
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row], for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cells[indexPath.row] == "RerservationCellID"{
            
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "heatingSegue", sender: self)
        case 2:
            self.performSegue(withIdentifier: "ecsSegue", sender: self)
        case 3:
            self.performSegue(withIdentifier: "commentsSegue", sender: self)
        case 4:
            print("photos")
            self.performSegue(withIdentifier: "photosSegue", sender: self)
        default:
            print("invalid option")
            }
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
}

class TechnicianClientCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var phoneLabel: UILabel?
}

class TechnicianReservationCell: UITableViewCell {
    @IBOutlet weak var reservationLabel: UILabel?
    @IBOutlet weak var detailsLabel: UILabel?
    @IBOutlet weak var reservationImage: UIImageView?
}

class TechnicianAdvancementCell: UITableViewCell {
    @IBOutlet weak var proggress: UISlider?
    @IBOutlet weak var alertLabel1: UILabel?
    @IBOutlet weak var alertLabel2: UILabel?
}
