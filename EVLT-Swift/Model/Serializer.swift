//
//  Serializer.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 11/24/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import Foundation
import UIKit

class Serializer: NSObject {
    
    class func convertStringToInteger(string: String) -> Int{
        let formatter = NumberFormatter()
        
        formatter.numberStyle = NumberFormatter.Style.decimal
        //validate if return null value
        if let number = formatter.number(from: string) as? Int {
            return number
        }else {
            return 0
        }
    }
    
    class func convertStringToDouble(string: String) -> Double{
        let formatter = NumberFormatter()
        
        formatter.numberStyle = NumberFormatter.Style.decimal
        //validate if return null value
        if let number = formatter.number(from: string) as? Double {
            return number
        }else {
            return 0
        }
    }
    
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

