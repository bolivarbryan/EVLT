//
//  StatusViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 2/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {
    var project:Project!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProjectValidationSegue" {
            let vc = segue.destination as! ProjectValidationViewController
            vc.project = self.project
        }
    }
    

}
