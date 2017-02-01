//
//  PersistencyManager.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 12/14/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import Foundation

class PersistencyManager: NSObject {
    static let sharedInstance : PersistencyManager = {
        let instance = PersistencyManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
}
