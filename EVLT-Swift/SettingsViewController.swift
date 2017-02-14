//
//  SettingsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 14/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = kSettingsTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let user = User(dictionary: UserDefaults.standard.value(forKey: KSessionData) as! Dictionary<String, Any>)
        return "Hello \(user.profil)."
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return "Version: " + version!
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 0 {
            //logout
            ELVTAlert.showConfirmationMessage(controller: self, message: kLogoutConfirm, completion: { (done) in
                if done == true {
                    //delete all data
                    UserDefaults.standard.set(nil, forKey: KSessionData)
                    UserDefaults.standard.removeObject(forKey: KSessionData)

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.navigationController!.present(vc, animated: true)
                }
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
            cell.textLabel?.text = kLogout
            cell.accessoryType = .disclosureIndicator
        return cell
    }
}
