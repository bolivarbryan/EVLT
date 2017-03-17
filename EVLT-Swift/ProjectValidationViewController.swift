//
//  ProjectValidationViewController.swift
//  EVLT-Swift
//
//  Created by Bryan on 2/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import UIKit
protocol ProjectValidationDelegate {
    func didValidate(total totalValue: Float, tax: Float)
}

class ProjectValidationViewController: UIViewController {
    var project: Project!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var tvaTxt: UITextField!
    var delegate:ProjectValidationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.project.status = .accepted
        
        self.priceTxt.text = "\(self.project.prix_ht)"
        self.tvaTxt.text = "\(self.project.tva)"
        
        let newButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .done, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = newButton
    }
    
    func edit() {
        let numberFormatter = NumberFormatter()
        
        self.project.prix_ht = numberFormatter.number(from: priceTxt.text!)?.floatValue ?? 0.0
        self.project.tva = numberFormatter.number(from: tvaTxt.text!)?.floatValue ?? 0.0
        self.delegate.didValidate(total: numberFormatter.number(from: priceTxt.text!)?.floatValue ?? 0.0, tax: self.project.tva)
        _ = self.navigationController?.popViewController(animated: true)
    }
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
