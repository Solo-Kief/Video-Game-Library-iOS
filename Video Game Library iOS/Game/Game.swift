//
//  Game.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import Foundation

class Game {
    var title: String
    var genra: String
    var rating: Rating
    var status: Status
    var description: String?
    var dueDate: Date?
    
    enum Rating {
        case E
        case E10
        case T
        case M
        case AO
    }
    
    enum Status {
        case checkedIn
        case checkedOut
    }
    
    init(title: String, genra: String, rating: Rating, description: String?, dueDate: Date?) {
        self.title = title
        self.genra = genra
        self.rating = rating
        self.status = .checkedIn
        self.description = description
        self.dueDate = dueDate
    }
}
