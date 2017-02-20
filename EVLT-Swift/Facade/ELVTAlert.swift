//
//  APIRequests.swift
//  EVLT-Swift
//
//  Created by Bryan on 14/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation
import UIKit

struct ELVTAlert {
    static func showConfirmationMessage(controller: UIViewController, message: String, completion: @escaping (_ done: Bool) -> Void) {
        
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: kAlertCancel, style: .cancel) { action in
            completion(false)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: kAlertOk, style: .default) { action in
            completion(true)
        }
        
        alertController.addAction(OKAction)
        
        controller.present(alertController, animated: true) {
            
        }
    }
    
    static func showMessage(controller: UIViewController, message: String, completion: @escaping (_ done: Bool) -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: kAlertOk, style: .default) { action in
            completion(true)
        }
        
        alertController.addAction(OKAction)
        
        controller.present(alertController, animated: true) {
            
        }
    }

    static func showFormWithFields(controller: UIViewController, message:String,  fields: [String], completion: @escaping  (_ results: Array<String>) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
       
        let loginAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { [weak alertController] _ in
            if let alertController = alertController {
                var fieldObjects:[String] = []
                for field in alertController.textFields! {
                    fieldObjects.append(field.text!)
                }
                
                completion(fieldObjects)
            }
        }
        
        for field in fields {
            alertController.addTextField { textField in
                textField.placeholder = field
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                    loginAction.isEnabled = textField.text != ""
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true) {
            
        }
    }
        
    
}
