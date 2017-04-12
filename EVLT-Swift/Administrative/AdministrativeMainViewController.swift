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
    var projectsFiltered = [Project]()
    var projectAddressArray: [(project: Project, address: Place)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getProjects()
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
        } else if segue.identifier == "projectsSegue" {
            let vc = segue.destination as! AdministrativeProgrammingViewController
            vc.projectAddressArray = self.projectAddressArray
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
            
            self.projectsFiltered = projects.filter { po in
                return po.status == ProjectStatus.accepted
            }
            
            DispatchQueue.main.async {
                self.count.text = "\(self.projectsFiltered.count) Workshops to be programmed"
            }
            
        }

    }
    
    func getProjects() {
        APIRequests.importAllProjects { (projects) in
            print(projects)
            self.projectAddressArray = []
            
            
            for projectObject in projects["chantiers"] as! Array<Dictionary<String, Any>> {
                let project = Project(dictionaryObject: projectObject)
                //got project, getting addresses
                for addressObject in projects["adresses"] as! Array<Dictionary<String, Any>> {
                    if "\(project.chantier_id)" == addressObject["chantier_id"] as! String {
                        //create address instance and combine it with project and add pin to map
                        let address = Place(dictionary: addressObject)
                        
                        if (project.statut_technicien != "") {
                            self.projectAddressArray.append((project: project, address: address))
                        }
                    }else{
                        continue
                    }
                    
                }
                
                self.projectAddressArray = self.projectAddressArray.filter { po in
                    return po.project.status == ProjectStatus.accepted
                }
                
                DispatchQueue.main.async {
                    self.count.text = "\(self.projectAddressArray.count) Workshops to be programmed"
                }
                
            }
            
            // dictionary projects, addresses
            
            //getting
        }
    }
    
    
}
