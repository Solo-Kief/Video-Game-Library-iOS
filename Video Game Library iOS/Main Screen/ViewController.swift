//  ViewController.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/15/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit

class ViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var gameList: [Game] = []
    var selectedGame: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameList.append(Game(title: "Overwatch", genre: "First Person Shooter", rating: .T, description: "It's basicaly new age Team Fortress 2"))
        gameList.append(Game(title: "Team Fortress 2", genre: "First Person Shooter", rating: .M, description: "The internet's favorite cluster-fuck."))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameShowViewController {
            destination.gameToShow = selectedGame
        }
    } //Allows me to do prep before segueing.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == gameList.count {
            self.performSegue(withIdentifier: "addGame", sender: self)
            return
        }
        
        selectedGame = gameList[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    } //Tells the segue what game it is when a row is selected.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == gameList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addGameCell")
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameCell
        cell.titleField.text = gameList[indexPath.row].title
        cell.genreField.text = gameList[indexPath.row].genre
        cell.ratingField.text = gameList[indexPath.row].rating.rawValue
        cell.statusField.text = gameList[indexPath.row].status.rawValue
        
        //Delete me
        if cell.titleField.text == "Overwatch" {
            cell.coverImageView.image = #imageLiteral(resourceName: "Boxart_overwatch")
        } else if cell.titleField.text == "Team Fortress 2" {
            cell.coverImageView.image = #imageLiteral(resourceName: "Tf2_standalonebox")
        }
        //
        
        return cell
    }
}
