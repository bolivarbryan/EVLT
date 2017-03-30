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
    
    static func showFormEditField(controller: UIViewController, message:String,  field: String, currentValue: String, completion: @escaping  (_ results: Array<String>) -> Void) {
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
        
        alertController.addTextField { textField in
            textField.placeholder = field
            textField.text = currentValue
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                loginAction.isEnabled = textField.text != ""
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        controller.present(alertController, animated: true) {
            
        }
    }
    
    static func showCameraPickerOptions(controller: UIViewController, message: String, completion: @escaping (_ done: Int) -> Void) {
        
        let alertController = UIAlertController(title: "Picture", message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: kAlertCancel, style: .cancel) { action in
            completion(0)//none
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Camera", style: .default) { action in
            completion(1)//camera
        }
        
        let GalleryAction = UIAlertAction(title: "Gallery", style: .default) { action in
            completion(2)//gallery
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(GalleryAction)
        
        controller.present(alertController, animated: true) {
            
        }
    }
    
    
}
