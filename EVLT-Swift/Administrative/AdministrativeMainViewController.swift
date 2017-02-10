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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAdministrativeData()
    }
    
    override func awakeFromNib() {
        self.navigationController?.tabBarItem.image = UIImage(named: "layer")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getAdministrativeData() {
        APIRequests.importProject()
    }

    

}
