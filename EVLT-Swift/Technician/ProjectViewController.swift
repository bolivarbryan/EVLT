//
//  ProjectViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: PROPERTIES
    var projectAddressArray: [(project: Project, address: Place)] = []
    var filteredProjectAddressArray: [(project: Project, address: Place)] = []
    
    var selectedProjectAddress: (project: Project, address: Place)!
    var parentVC: UIViewController? = nil
    var parentController: String? = nil
    var hasParentVC: Bool {
        get {
            if let _ = self.parentVC {
                return true
            } else {
                return false
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    
    func setupSearchEngine(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.isTranslucent = false
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewDidLoad() {
        self.filteredProjectAddressArray = projectAddressArray
        super.viewDidLoad()
        self.configureTableView()
        self.setupSearchEngine()
        
        self.title = NSLocalizedString("Projects", comment: "")
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ProjectUpdatesViewController
            vc.projectAddress = selectedProjectAddress
            vc.parentController = parentController
        }
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredProjectAddressArray = projectAddressArray.filter { projectAddress in
            return (projectAddress.project.clientName?.lowercased().contains(searchText.lowercased()))!
        }
        
        if searchText.isEmpty {
            filteredProjectAddressArray = self.projectAddressArray
        }
        
        tableView.reloadData()

    }
    
    
    //MARK: TABLEVIEW

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCellTableViewCell
        cell.nameLabel?.text = filteredProjectAddressArray[indexPath.row].project.clientName
        
        if hasParentVC == true {
            cell.subtitleLabel?.text = "\(filteredProjectAddressArray[indexPath.row].address.formattedAddress())"
        }else {
            cell.subtitleLabel?.text = "\(filteredProjectAddressArray[indexPath.row].project.type) - \(filteredProjectAddressArray[indexPath.row].project.statut_technicien)"
        }
        
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredProjectAddressArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if hasParentVC == false {
            tableView.deselectRow(at: indexPath, animated: true)
            self.selectedProjectAddress = filteredProjectAddressArray[indexPath.row]
            self.performSegue(withIdentifier: "segue", sender: self)
        //}
    }
}


extension ProjectViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
