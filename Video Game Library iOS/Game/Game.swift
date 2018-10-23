//  Game.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import Foundation

class Game: NSObject, NSCoding {
    static var gameList: [Game] = [] //Used by anything that needs access to game data.
    var title: String
    var genre: String
    var rating: Rating
    var status: Status
    var Description: String?
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
        self.Description = description
        self.dueDate = nil
    }
    
    //Everything below here concerns persistance.
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let genre = aDecoder.decodeObject(forKey: "genre") as! String
        let rating = aDecoder.decodeObject(forKey: "rating") as! String
        let status = aDecoder.decodeObject(forKey: "status") as! String
        let description = aDecoder.decodeObject(forKey: "description") as? String
        let dueDate = aDecoder.decodeObject(forKey: "dueDate") as? Date
        
        let sendRating = Game.Rating(rawValue: rating)
        let sendStatus = Game.Status(rawValue: status)
        
        self.init(title: title, genre: genre, rating: sendRating!, description: description)
        self.status = sendStatus!
        self.dueDate = dueDate
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title , forKey: "title")
        aCoder.encode(genre , forKey: "genre")
        aCoder.encode(rating.rawValue , forKey: "rating")
        aCoder.encode(status.rawValue , forKey: "status")
        aCoder.encode(Description , forKey: "description")
        aCoder.encode(dueDate , forKey: "dueDate")
    }
    
    static func saveArray() {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: gameList), forKey: "games")
    }
    
    static func loadArray() {
        guard let gameData = UserDefaults.standard.value(forKey: "games") else {
            return
        }
        let games = NSKeyedUnarchiver.unarchiveObject(with: gameData as! Data)
        gameList = games as! [Game]
    }
    
    static func refreshArray() {
        saveArray()
        loadArray()
    }
}
