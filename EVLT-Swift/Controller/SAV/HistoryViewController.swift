//
//  HistoryViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 4/3/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    var histories = [History]()
    @IBOutlet weak var tableView: UITableView!
    var project:Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("History", comment: "")
        self.getHistoryReports()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HistoryViewController {
    func getHistoryReports() {
        //mock
        for x in 0...3 {
            let history = History(historyDescription: "History Report", timestamp: 1490989474, price: 500, isPaid: (x % 2 == 0))
            histories.append(history)
        }
        self.tableView.reloadData()
    }
}

class HistoryCell:UITableViewCell {

    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}

//MARK: Tableview Protocols
extension HistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HistoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)  as! HistoryCell
        cell.historyLabel?.text = histories[indexPath.row].formattedDescription()
        
        if histories[indexPath.row].isPaid == true {
            cell.icon.image = #imageLiteral(resourceName: "checkmark")
        } else {
            cell.icon.image = #imageLiteral(resourceName: "Exclamation Mark")
        }
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
