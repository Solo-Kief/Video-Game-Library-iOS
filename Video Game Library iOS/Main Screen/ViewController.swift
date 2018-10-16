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
        gameList.append(Game(title: "Overwatch", genra: "First Person Shooter", rating: .E10, description: "It's basicaly new age Team Fortress 2"))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameShowViewController {
            destination.gameToShow = selectedGame
        }
    } //Allows me to do prep before segueing.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = gameList[indexPath.row]
        self.performSegue(withIdentifier: "showDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    } //Tells the segue what game it is when a row is selected.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameCell
        cell.titleField.text = gameList[indexPath.row].title
        cell.genreField.text = gameList[indexPath.row].genra
        cell.ratingField.text = gameList[indexPath.row].rating.rawValue
        cell.statusField.text = gameList[indexPath.row].status.rawValue
        return cell
    }
}
