//  ViewController.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/15/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit

class ViewControler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedGame: Int?
    
    @IBOutlet var liveTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Game.loadArray()

//        Game.gameList.append(Game(title: "Test", genre: "Genra", rating: .E, description: nil))
//        Game.saveArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        liveTableView.reloadData()
    } //Forces the table to reflect changes made elsewhere.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GameShowViewController {
            destination.gameSelector = selectedGame
        }
    } //Allows me to do prep before segueing.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Game.gameList.count {
            self.performSegue(withIdentifier: "addGame", sender: self)
            return
        }
        
        selectedGame = indexPath.row
        self.performSegue(withIdentifier: "showDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    } //Tells the segue what game it is when a row is selected.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Game.gameList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == Game.gameList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addGameCell")
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameCell
        cell.titleField.text = Game.gameList[indexPath.row].title
        cell.genreField.text = Game.gameList[indexPath.row].genre
        cell.ratingField.text = Game.gameList[indexPath.row].rating.rawValue
        
        if Game.gameList[indexPath.row].status == .checkedOut {
            let format = DateFormatter()
            format.dateFormat = "MM/dd/yy"
            
            cell.statusField.text = "\(Game.gameList[indexPath.row].status.rawValue) - Due: \(format.string(from: Game.gameList[indexPath.row].dueDate!))"
        } else {
            cell.statusField.text = Game.gameList[indexPath.row].status.rawValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, _ in
            Game.gameList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            Game.refreshArray()
        }
        
        let title = Game.gameList[indexPath.row].status == .checkedIn ? "Check Out" : "Check In"
        
        let checkOutOrInAction = UITableViewRowAction(style: .normal, title: title) { _, _ in
            if Game.gameList[indexPath.row].status == .checkedIn {
                Game.gameList[indexPath.row].status = .checkedOut
                Game.gameList[indexPath.row].dueDate = Date().addingTimeInterval(1209600)
            } else {
                Game.gameList[indexPath.row].status = .checkedIn
                Game.gameList[indexPath.row].dueDate = nil
            }
            
            tableView.reloadRows(at: [indexPath], with: .fade)
            Game.refreshArray()
        }
        
        return [deleteAction, checkOutOrInAction]
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
//            Game.gameList.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//        
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
}
