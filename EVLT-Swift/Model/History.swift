//
//  History.swift
//  EVLT-Swift
//
//  Created by Bryan on 31/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct History {
    var historyDescription: String
    var timestamp: Double?
    var price: Double?
    var isPaid: Bool?
    var date: String? {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            
            guard let timeStampValue = timestamp else {
                return nil
            }
            
            let date = Date(timeIntervalSince1970: timeStampValue)
            return formatter.string(from: date)
            
        }
    }
    
    init(historyDescription: String, timestamp: Double? = nil, price: Double? = nil, isPaid:Bool? = nil) {
        self.historyDescription = historyDescription
        self.timestamp = timestamp
        self.price = price
        self.isPaid = isPaid
    }
}

extension History {
    func formattedPrice() -> String? {
        guard let price = self.price else {
                return nil
        }
        return "€\(Int(price))"
    }
    
    func formattedDescription() -> String? {
        guard let date = self.date else { return nil }
        guard let price = self.formattedPrice() else { return nil }
        return "\(self.historyDescription) le \(date) \(price)"
    }
}
