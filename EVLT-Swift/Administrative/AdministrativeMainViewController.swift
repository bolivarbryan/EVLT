//
//  AdministrativeMainViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class AdministrativeMainViewController: UIViewController {
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var plannificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAcceptedProjects()
        self.count.text = "# Workshops to be programmed"
    }
    
    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "layer")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newclientSegue" {
            let vc = segue.destination as! NewClientViewController
            vc.fromVC = "Administrative"
        }
    }
}


extension AdministrativeMainViewController {
    
    func getAcceptedProjects() {
        
        APIRequests.importProject { (results) in
            print(results)
            
            var projects = [Project]()
            for projectObject in results as! Array<Dictionary<String, Any>> {
                let project = Project(dictionaryObject: projectObject)
                projects.append(project)
            }
            
            let projectsFiltered = projects.filter { po in
                return po.status == ProjectStatus.accepted
            }
            
            DispatchQueue.main.async {
                self.count.text = "\(projectsFiltered.count) Workshops to be programmed"
            }
            
        }

    }
}
