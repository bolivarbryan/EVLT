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
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var searchBar: UISearchBar!
    var selectedClient: Client!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ClientsListViewController.getCommercialData), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getCommercialData()
        self.setupSearchEngine()
        
        self.tableView.backgroundView = self.refreshControl
        
        let newButton = UIBarButtonItem(title: kNewClient, style: .done, target: self, action: #selector(new))
        self.navigationItem.rightBarButtonItem = newButton
        
    }
    
    func new() {
        self.performSegue(withIdentifier: "newClientSegue", sender: self)
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
            self.tableView.reloadData()
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
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.nameLabel.text = filteredClients[indexPath.row].fullName().capitalized
        }else{
            cell.nameLabel.text = clients[indexPath.row].fullName().capitalized
        }
        
        //cell.subtitleLabel.text = clients[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredClients.count
        }
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedClient = clients[indexPath.row]
        self.performSegue(withIdentifier: "segue", sender: self)
    }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredClients = clients.filter { client in
            return client.lastName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}



extension ClientsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension ClientsListViewController: NewClientDelegate {
    
    func clientSuccessfullyCreated() {
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



