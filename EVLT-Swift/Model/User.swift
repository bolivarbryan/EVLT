//
//  User.swift
//  EVLT-Swift
//
//  Created by Bryan A Bolivar M on 12/6/16.
//  Copyright © 2016 Wiredelta. All rights reserved.
//

import Foundation

struct User {
    var username = ""
    var profil = ""
    
    init(username: String, profil: String) {
        self.username = username
        self.profil = profil
    }
    
    init(dictionary: Dictionary<String, Any>) {
        self.username = dictionary["login"] as! String
        self.profil = dictionary["profil"] as! String
    }
}

extension User {
     func dictionaryValue() -> Dictionary<String, Any> {
        var d = Dictionary<String, Any>()
        d["login"] = self.username
        d["profil"] = self.profil
        return d
    }
}
