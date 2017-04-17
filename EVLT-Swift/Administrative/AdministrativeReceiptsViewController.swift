//
//  AdministrativeReceiptsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/31/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class AdministrativeReceiptsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var prices = [Price]()
    var payments = [Payment]()
    var clients = [Client]()
    var composedPayments = [ComposedPayment]()
    var selectedIndex: Int!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AdministrativeReceiptsViewController.getInformation), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.tableView.backgroundView = self.refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getInformation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! AdministrativePaymentViewController
            vc.composedPaymentInfo = composedPayments[selectedIndex]
        }
    }
    
    //MARK: tableview
    @IBOutlet weak var tableView: UITableView!
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! PaymentTableViewCell
        cell.index = indexPath.row
        cell.delegate = self
        let c = composedPayments[indexPath.row]
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
        
        cell.notPayableLabel.text = NSLocalizedString("Do not payable:", comment: "") + " \(notExigible) €"
        cell.redValueLabel.text = "\(c.totalMinusValues) €"
        cell.totalHTLabel.text = NSLocalizedString("Total (HT):", comment: "") + " \(c.totalAmountHT) €"
        cell.totalTCCLabel.text = NSLocalizedString("Total TTC:", comment: "") + " \(c.totalAmountTTC) €"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.composedPayments.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

struct ComposedPayment {
    var client: Client!
    var totalAmmount: Float
    var totalPlusValues: Float
    var totalTCCPlusValues: Float
    
    var totalTTCMinusValues: Float = 0.0
    var totalMinusValues: Float = 0.0
    var totalAmountHT: Float = 0.0
    var totalAmountTTC: Float = 0.0
    var totalPay: Float = 0.0
    var totalExigible: Float = 0.0
}
