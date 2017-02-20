//
//  Zone.swift
//  EVLT-Swift
//
//  Created by Bryan on 18/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct Zone {
    var name:String // nom
    var volume: String // volume
    var walls: String //murs
    var attic: String //combles
    var groundStaff: String //rampants
    var carpentry: String // Menuiserie
    var projectID: String?
    var zoneID: String?
    
    init(name: String, volume: String, walls: String, attic: String, groundStaff: String, carpentry: String) {
        self.name = name
        self.volume = volume
        self.walls = walls
        self.attic = attic
        self.groundStaff = groundStaff
        self.carpentry = carpentry
    }
}
