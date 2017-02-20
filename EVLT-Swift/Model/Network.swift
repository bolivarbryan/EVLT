//
//  Network.swift
//  EVLT-Swift
//
//  Created by Bryan on 19/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct Network {
    var existing: String
    var radiators: String
    var material: String
    var diameter: String
    
    var netWorkId: String?
    var projectId: String?
    var name: String?
    
    init(existing: String, radiators: String, material: String, diameter: String) {
        self.existing = existing
        self.radiators = radiators
        self.material = material
        self.diameter = diameter
    }
}
