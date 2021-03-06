//
//  ClientsListViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class ClientsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var clients: [Client] = []
    var filteredClients: [Client] = []
    var filteredClientsByStatus: [Client] = []
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var clientsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedClient: Client!
    var filterClientsStatusString = Client.ClientStatus.visit.rawValue
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ClientsListViewController.getCommercialData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.setupSearchEngine()
        filterClientsStatusString = Client.ClientStatus.visit.rawValue
        self.tableView.backgroundView = self.refreshControl
        
        let newButton = UIBarButtonItem(title: kNewClient, style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCommercialData()

    }
    
    func new() {
        self.performSegue(withIdentifier: "newClientSegue", sender: self)
    }
    
    @IBAction func reloadBySection(_ sender: UISegmentedControl) {
        print()
        var clients = [Client]()
        if searchController.isActive && searchController.searchBar.text != "" {
            clients = self.filteredClients
        }else{
            clients = self.clients
        }
        
        var queryString = ""
        switch sender.selectedSegmentIndex {
        case 0:
            queryString = "Visite faite"
        case 1:
            queryString = "Actif"
        case 2:
            queryString = "Accepte"
        case 3:
             queryString = "Inactif"
        default:
            queryString = "All"
        }
        self.filterClientsStatusString = queryString
        
        if queryString != "All" {
            self.filterClientsByStatus(clients: clients, status: Client.ClientStatus(rawValue: queryString)!)
        }else {
            self.filterContentForSearchText(searchText: "")
        }
    }
    
    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "briefcase")
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCommercialData() {
        APIRequests.startFilling { (clients) in
            self.clients = clients
            self.filteredClients = self.clients
            self.filteredClientsByStatus = self.filteredClients
            switch self.clientsSegmentedControl.selectedSegmentIndex {
            case 0:
                self.filterClientsStatusString = "Visite faite"
            case 1:
                self.filterClientsStatusString = "Actif"
            case 2:
                self.filterClientsStatusString = "Accepte"
            case 3:
                self.filterClientsStatusString = "Inactif"
            default:
                self.filterClientsStatusString = "All"
            }
            
            
            self.filterContentForSearchText(searchText: "", scope: self.filterClientsStatusString)
            
            //self.filterClientsByStatus(clients: self.clients, status: Client.ClientStatus(rawValue: self.filterClientsStatusString) ?? .all )
            self.refreshControl.endRefreshing()
        }
    }
    
    //prepareforsegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! CommercialProjectsViewController
            vc.client = selectedClient
        }else if segue.identifier == "newClientSegue" {
            let vc = segue.destination as! NewClientViewController
            vc.delegate = self
        }
    }

    //MARK: tableview
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCellTableViewCell
        cell.nameLabel.text = filteredClientsByStatus[indexPath.row].fullName()
        cell.subtitleLabel.text = filteredClientsByStatus[indexPath.row].address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClientsByStatus.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedClient = filteredClientsByStatus[indexPath.row]
        self.performSegue(withIdentifier: "segue", sender: self)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredClients = clients.filter { client in
            return client.lastName.lowercased().contains(searchText.lowercased())
        }
        if  self.filterClientsStatusString == "All" {
            if searchText.isEmpty {
                filteredClientsByStatus = self.clients
            }else{
                filteredClientsByStatus = filteredClients
            }
            let clientsSet = Set(filteredClientsByStatus)
            filteredClientsByStatus = Array(clientsSet)
            tableView.reloadData()

        }else{
            if searchText.isEmpty {
               filteredClients = clients
            }
            filterClientsByStatus(clients: filteredClients, status: Client.ClientStatus(rawValue: self.filterClientsStatusString)!)
        }
    }
    
    func filterClientsByStatus(clients:[Client] , status: Client.ClientStatus) {
        //creating a set
        
        filteredClientsByStatus = clients.filter { client in
            let status = client.status?.rawValue.lowercased() ?? "all"
            return (status == (self.filterClientsStatusString.lowercased()))
        }
    
        let clientsSet = Set(filteredClientsByStatus)
        print(clientsSet)
        filteredClientsByStatus = Array(clientsSet)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            var client: Client? = nil
            
            client = self.filteredClientsByStatus[indexPath.row]
            ELVTAlert.showConfirmationMessage(controller: self, message: NSLocalizedString("Are you you sure you want to delete " + client!.fullName(), comment: ""), completion: { (done) in
                if done == true {
                    //api call to delete
                    let query = "DELETE FROM `envertlaevlt`.`client` WHERE `client`.`client_id` = \(client!.clientID)"
                    APIRequests.deleteRecord(query: query , completion: { (done) in
                        self.searchDisplayController?.setActive(false, animated: true)
                        self.getCommercialData()
                    })
                }
            })
        }
        
        delete.backgroundColor = .red
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}



extension ClientsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension ClientsListViewController: NewClientDelegate {
    
    func clientSuccessfullyCreated() {
        self.clientsSegmentedControl.selectedSegmentIndex = 4
        self.reloadBySection(self.clientsSegmentedControl)
        //reload data and select the last item from array of clients
        APIRequests.startFilling { (clients) in
            self.clients = clients
            self.tableView.reloadData()
            self.selectedClient = clients[clients.count - 1]
             DispatchQueue.main.async {
                self.performSegue(withIdentifier: "segue", sender: self)
            }
        }
    }
    
    func clientCanceled() {
    }
}



