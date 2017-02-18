//
//  NewProjectViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

protocol NewProjectDelegate {
    func projectSuccessfullyCreated()
    func projectCanceled()
}

class NewProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: NewProjectDelegate!
    @IBOutlet weak var tableView: UITableView!
    var client:Client!
    
    let projects = [(title: "Projects", values: ["Stove", "Boiler", "Heat Pump", "Thermodynamic balloon", "Solar" ]), (title: "Energy", values: ["Pellets", "Wood logs", "Gas", "Fuel", "Thermal", "PV" ])]
    
    var currentSelection:(title: String, value: String)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        let back = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = done
    }
    
    func goBack() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    func save() {
        //data for create new project
        
        let string = "Installation \(self.currentSelection!.value)"
        
        APIRequests.newProject(type: string, client: self.client) { (results) in
            print(results)
            DispatchQueue.main.async {
                self.delegate.projectSuccessfullyCreated()
                self.navigationController?.dismiss(animated: true, completion: nil)
                //self.performSegue(withIdentifier: "segue", sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: tableview
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return projects[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projects.count
    }
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        cell.textLabel?.text = projects[indexPath.section].values[indexPath.row]
        
        if let selection = currentSelection {
            if (selection.value == projects[indexPath.section].values[indexPath.row]) && (selection.title == projects[indexPath.section].title) {
                cell.accessoryType = .checkmark
            }else {
                cell.accessoryType = .none
            }
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects[section].values.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentSelection = (title: projects[indexPath.section].title, value: projects[indexPath.section].values[indexPath.row])
        self.tableView.reloadData()
    }

}
