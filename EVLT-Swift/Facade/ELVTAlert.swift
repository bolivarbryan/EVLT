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

}
