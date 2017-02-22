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
    var kAddString = NSLocalizedString("Add...", comment: "")
    var project: Project? = nil
    
    let projects = [(title: "Projects", values: ["Chaudière gaz", "Chaudière fioul", "Chaudière bois", "Chaudière granulés", "Pompe à chaleur", "Insert bois", "Insert granulés", "Poêle à bois", "Poêle à granulés", "Ballon ECS", "Ballon thermodynamique", "Plancher chauffant", "Réseau de radiateurs", "Sanitaire", "Plomberie"]), (title: "Other", values: ["Add..."])]
    
    var currentSelection:(title: String, value: String)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        let back = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = back
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = done
        
        if self.project != nil {
            self.title = NSLocalizedString("Edit", comment: "")
            self.navigationItem.backBarButtonItem?.title = "Cancel"
            var i = 0
            
            for projectObject in projects[0].values {
                if self.project?.type == projectObject {
                    self.currentSelection = (title: projects[0].title, value: projects[0].values[i])
                }
                i = i + 1
            }
            
            if self.currentSelection == nil {
                self.currentSelection = (title: projects[1].title, value: projects[1].values[0])
            }
        }

    }
    
    func goBack() {
        if self.project != nil {
            _ = self.navigationController?.popViewController(animated: true)
        }else {
            self.navigationController?.dismiss(animated: true, completion: nil)

        }
    }

    func save() {
        let edit = (project != nil)
        
        if currentSelection != nil {
            //data for create new project
            if self.currentSelection?.value == kAddString {
                //ask for new name
                ELVTAlert.showFormWithFields(controller: self,message: NSLocalizedString("Name of the project", comment: "") , fields: ["Nom"], completion: { (values) in
                    if values.count > 0 {
                        let string = "\(values[0])"
                        
                        //FIXME: complete edit
                        
                        APIRequests.newProject(edit:edit, type: string, client: self.client) { (results) in
                            print(results)
                            DispatchQueue.main.async {
                                self.delegate.projectSuccessfullyCreated()
                                if edit == true {
                                    _ = self.navigationController?.popViewController(animated: true)
                                }else {
                                    self.navigationController?.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                })
            }else {
                
                let string = "\(self.currentSelection!.value)"
                
                APIRequests.newProject(edit: edit, type: string, client: self.client) { (results) in
                    print(results)
                    DispatchQueue.main.async {
                        self.delegate.projectSuccessfullyCreated()
                        if edit == true {
                            _ = self.navigationController?.popViewController(animated: true)
                        }else {
                            self.navigationController?.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }else{
            ELVTAlert.showMessage(controller: self, message: NSLocalizedString("Select an option first", comment: ""), completion: { (done) in })
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
