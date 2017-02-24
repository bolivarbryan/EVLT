//
//  TechnicianCommentsViewController.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 10/30/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import UIKit

class TechnicianCommentsViewController: UIViewController {
    var project: Project!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.project.comments != nil {
            self.textView.text = project.comments!
        }
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
