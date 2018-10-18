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
    var genre: String
    var rating: Rating
    var status: Status
    var description: String?
    var dueDate: Date?
    
    enum Rating: String {
        case E = "E - Everyone"
        case E10 = "E10 - Everyone 10 and Up"
        case T = "T - Teen"
        case M = "M - Mature"
        case AO = "AO - Adult Only"
    }
    
    enum Status: String {
        case checkedIn = "Checked In"
        case checkedOut = "Checked Out"
    }
    
    init(title: String, genre: String, rating: Rating, description: String?) {
        self.title = title
        self.genre = genre
        self.rating = rating
        self.status = .checkedIn
        self.description = description
        self.dueDate = nil
    }
}
