//
//  CommercialProjectDetailsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class CommercialProjectDetailsViewController: UIViewController {
    var project: Project!
    var client: Client!
    var currentPlace: Place!
    
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
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchProjectDetails(completion: @escaping (_ completion: Project?) -> Void) {
        
        APIRequests.importProjectDetails(chantierID: "\(self.project.chantier_id)") { (projectObject) in
            print(projectObject.0! as Project)
            print(projectObject.1! as Place)
            if let place = projectObject.1 {
                self.currentPlace = place
                completion(nil)
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
            }
      
            
            
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddressSegue"{
            var vc = segue.destination as! CommercialContactInformationViewController
            vc.place = currentPlace
            vc.project = self.project
        }
    }
    

}
