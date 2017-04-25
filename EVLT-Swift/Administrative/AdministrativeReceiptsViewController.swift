//
//  AdministrativeReceiptsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

extension AdministrativeReceiptsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredComposedPayments = composedPayments.filter { composedPayment in
            return (composedPayment.client.fullName().lowercased().contains(searchText.lowercased()))
        }
        
        if searchText.isEmpty {
            filteredComposedPayments = self.composedPayments
        }
        
        tableView.reloadData()
        
    }
    
}

class AdministrativeReceiptsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var prices = [Price]()
    var payments = [Payment]()
    var clients = [Client]()
    var composedPayments = [ComposedPayment]()
    var filteredComposedPayments = [ComposedPayment]()
    
    var selectedIndex: Int!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AdministrativeReceiptsViewController.getInformation), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
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
        super.viewDidLoad()
        self.configureTableView()
        self.tableView.backgroundView = self.refreshControl
        self.setupSearchEngine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchController.isActive = false
        self.getInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! AdministrativePaymentViewController
            vc.composedPaymentInfo = filteredComposedPayments[selectedIndex]
        }else if segue.identifier == "TotalID" {
            let vc = segue.destination as! AdministrativeTotalExigibleByCustomerViewController
            vc.payments = self.filteredComposedPayments
        }
    }
    
    //MARK: tableview
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! PaymentTableViewCell
        cell.index = indexPath.row
        cell.delegate = self
        let c = filteredComposedPayments[indexPath.row]
        cell.clientNameLabel.text = c.client.fullName()
        
        cell.estimatedAmmountLabel.text = NSLocalizedString("Initial estimated amount (HT):", comment: "") + " \(c.totalAmmount) €"
        cell.greenValueLabel.text = "\(c.totalPlusValues) €"
        cell.totalTCCLabel.text = "\(c.totalTCCPlusValues) €"
        cell.ammountLabel.text = NSLocalizedString("Received amount:", comment: "") + " \(c.totalPay) €"
        cell.leftToPayLabel.text = NSLocalizedString("Left to pay:", comment: "") + " \(c.totalAmountTTC - c.totalPay ) €"
        
        var notExigible:Float = 0
        if c.totalExigible  > c.totalPay {
            notExigible = c.totalExigible - c.totalPay
        }
        
        cell.notPayableLabel.text = NSLocalizedString("Exigible:", comment: "") + " \(notExigible) €"
        cell.redValueLabel.text = "\(c.totalMinusValues) €"
        cell.totalHTLabel.text = NSLocalizedString("Total (HT):", comment: "") + " \(c.totalAmountHT) €"
        cell.totalTCCLabel.text = NSLocalizedString("Total TTC:", comment: "") + " \(c.totalAmountTTC) €"
        
        return cell
    }
    
    func showTotalExigibleView(){
        performSegue(withIdentifier: "TotalID", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredComposedPayments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let color:CGFloat = 242/255.0
        view.backgroundColor = UIColor(red: color, green: color, blue: color, alpha: 1.0)
        
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .natural
        
        let attrs = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 16.0),
            NSForegroundColorAttributeName : UIColor.darkGray,
            NSParagraphStyleAttributeName: paragraph] as [String : Any]
       
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:"Show total exigible by customer", attributes:attrs)
        attributedString.append(buttonTitleStr)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 24, height: 44))
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(showTotalExigibleView), for: .touchUpInside)
        
        let arrow = UIImageView(image: #imageLiteral(resourceName: "Disclosure Indicator"), highlightedImage: nil)
        arrow.frame = CGRect(x: UIScreen.main.bounds.width - 16, y: 15, width: 9, height: 14)
        
        let line = UIView(frame: CGRect(x: 0, y: 43, width: UIScreen.main.bounds.width, height: 1))
        line.backgroundColor = UIColor.darkGray
        
        view.addSubview(button)
        view.addSubview(arrow)
        view.addSubview(line)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func getInformation()  {
        APIRequests.importProject { (response) in
            print(response)
            let projects = (response as! Array<Dictionary<String, Any>>).map { projectObject in
                return Project(dictionaryObject: projectObject)
            }
            
            //getting prices
            APIRequests.importAllPrices { (prices) in
               
                //getting payments
                APIRequests.importAllPayments { (payments) in
                    
                    var filteredPrices = prices.filter { price in
                        return price.statusPayment == "en cours"
                    }
                    
                    //filtering projects
                    for (index, _) in filteredPrices.enumerated() {
                        for (index2, _) in projects.enumerated() {
                            if filteredPrices[index].siteID == projects[index2].chantier_id {
                                filteredPrices[index].clientID = projects[index2].client_id
                            }
                        }
                    }
                    
                    //getting clients from api
                    APIRequests.startFilling(completion: { (clients) in
                        let selectedClients = clients.filter { client in
                            for p in filteredPrices {
                                if "\(p.clientID!)" == client.clientID {
                                    return true
                                }
                            }
                            return false
                        }
                        
                        self.payments = payments
                        self.prices = filteredPrices
                        self.clients = selectedClients
                        
                        self.composedPayments =  selectedClients.map { client in
                            
                            var totalAmmount:Float = 0.0
                            var totalPlusValues:Float = 0.0
                            var totalTTCPlusValues: Float = 0.0
                            
                            var totalTTCMinusValues: Float = 0.0
                            var totalMinusValues: Float = 0.0
                            var totalAmountHT: Float = 0.0
                            var totalAmountTTC: Float = 0.0
                            var totalPay: Float = 0.0
                            var totalExigible: Float = 0.0
                            
                            for payment in payments {
                                if payment.clientID == client.clientID {
                                    totalPay = totalPay + (payment.ammount as NSString).floatValue
                                }
                            }
                            
                            for p in filteredPrices {
                                if "\(p.clientID!)" == client.clientID {
                                    totalAmmount = totalAmmount + (p.priceHT as NSString).floatValue
                                    totalPlusValues = totalPlusValues + p.plusValues
                                    totalTTCPlusValues = totalPlusValues * (1 + (Float(p.tva)/100))
                                    totalMinusValues = totalMinusValues + p.lessCapital
                                    totalTTCMinusValues = totalMinusValues * (1 + (Float(p.tva)/100))
                                    totalAmountHT = totalAmountHT + (p.priceHT as NSString).floatValue
                                    totalAmountTTC = totalAmountTTC + ((p.priceHT as NSString).floatValue * (1 + (Float(p.tva)/100)))
                                    
                                    let totalExigibleProject = ((p.priceHT as NSString).floatValue * (1 + (Float(p.tva)/100))) * ((p.percentageDue as NSString).floatValue/100)
                                    
                                    totalExigible = totalExigibleProject + totalTTCPlusValues - totalTTCMinusValues
                                }
                            }
                            
                            
                            return ComposedPayment(client: client, totalAmmount: totalAmmount, totalPlusValues: totalPlusValues, totalTCCPlusValues: totalTTCPlusValues, totalTTCMinusValues: totalTTCMinusValues, totalMinusValues: totalMinusValues, totalAmountHT: totalAmountHT, totalAmountTTC: totalAmountTTC, totalPay: totalPay, totalExigible: totalExigible)
                            
                            
                        }
                        self.filteredComposedPayments = self.composedPayments
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                        }
                    })
                    
                }
            }
        }
    }

}

extension AdministrativeReceiptsViewController: PaymentTableViewCellDelegate {
    func didPressPaymentButton(index: Int) {
        print(index)
        self.selectedIndex = index
        self.performSegue(withIdentifier: "segue", sender: self)
    }
}

/*Payment tableview cell*/
//TODO: Move this to an independent file
protocol PaymentTableViewCellDelegate {
    func didPressPaymentButton(index: Int)
}

class PaymentTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var leftToPayLabel: UILabel!
    @IBOutlet weak var notPayableLabel: UILabel!
    @IBOutlet weak var estimatedAmmountLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var totalHTLabel: UILabel!
    @IBOutlet weak var totalTCCLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var clientNameLabel: UILabel!
    
    var index: Int!
    var delegate: PaymentTableViewCellDelegate?

    
    @IBAction func didPressPayment(_ sender: Any) {
        
        guard let d = delegate else {
            return
        }
        
        d.didPressPaymentButton(index: index)
    }
}

//TODO: Move This to an independent File

class ComposedPayment: Equatable {
    var client: Client!
    var totalAmmount: Float = 0.0
    var totalPlusValues: Float = 0.0
    var totalTCCPlusValues: Float = 0.0
    
    var totalTTCMinusValues: Float = 0.0
    var totalMinusValues: Float = 0.0
    var totalAmountHT: Float = 0.0
    var totalAmountTTC: Float = 0.0
    var totalPay: Float = 0.0
    var totalExigible: Float = 0.0
    
    init(client: Client, totalAmmount: Float, totalPlusValues: Float, totalTCCPlusValues: Float,  totalTTCMinusValues: Float, totalMinusValues: Float,  totalAmountHT: Float, totalAmountTTC: Float, totalPay: Float, totalExigible: Float) {
        self.client = client
        self.totalAmmount = totalAmmount
        self.totalPlusValues = totalPlusValues
        self.totalTCCPlusValues = totalTCCPlusValues
        
        self.totalTTCMinusValues = totalTTCMinusValues
        self.totalMinusValues = totalMinusValues
        self.totalAmountHT = totalAmountHT
        self.totalAmountTTC = totalAmountTTC
        self.totalPay = totalPay
        self.totalExigible = totalExigible
    }
}

func ==(lhs: ComposedPayment, rhs: ComposedPayment) -> Bool {
    return lhs.client.clientID == rhs.client.clientID
}
