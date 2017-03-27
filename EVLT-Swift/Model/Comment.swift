//
//  Comment.swift
//  EVLT-Swift
//
//  Created by Bryan on 27/03/17.
//  Copyright © 2017 Wiredelta. All rights reserved.
//

import Foundation



struct Comment {
    var type: CommentType
    var comment: String
    var projectId: Int
    
    init(type: CommentType, comment: String, projectId: Int) {
        self.type = type
        self.comment = comment
        self.projectId = projectId
    }
    
     enum CommentType: String {
        case Technician = "Technicien"
        case Administrative = "Administrative"
        case Commercial = "Commercial"
    }
}
