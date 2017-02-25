//
//  Photo.swift
//  EVLT-Swift
//
//  Created by Bryan on 24/02/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation

struct Photo {
    var url: String
    var comment: String
    var photoID:String?
    init(url: String, comment: String) {
        self.url = url
        self.comment = comment
    }
}
