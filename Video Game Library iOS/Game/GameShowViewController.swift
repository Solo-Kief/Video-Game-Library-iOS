//
//  GameShowViewController.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import UIKit

class GameShowViewController: UIViewController {
    var gameToShow: Game?
    //MUST BE MODIFIED TO ACCESS MAIN LIST WHEN PERSISTANCE IS ADDED.
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var genraField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var checkInOut: UIButton!
    
    let format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        format.dateStyle = .medium
        
        titleField.text = gameToShow?.title
        genraField.text = gameToShow?.genra
        ratingField.text = gameToShow?.rating.rawValue
        if gameToShow?.status == Game.Status.checkedOut {
            statusField.text = "\(gameToShow?.status.rawValue ?? "") - Due: \(format.string(from: (gameToShow?.dueDate)!))"
            checkInOut.setTitle("Check In", for: .normal)
        } else {
            statusField.text = gameToShow?.status.rawValue
        }
        descriptionField.text = gameToShow?.description
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInOut(_ sender: UIButton) {
        //MUST BE UPDATED WHEN PERSISTANCE IS ADDED
        if gameToShow?.status == .checkedIn {
            gameToShow?.status = .checkedOut
            gameToShow?.dueDate = Date().addingTimeInterval(1209600)
            sender.setTitle("Check In", for: .normal)
            statusField.text = "\(gameToShow?.status.rawValue ?? "") - Due:  \(format.string(from: (gameToShow?.dueDate)!))"
        } else {
            gameToShow?.status = .checkedIn
            gameToShow?.dueDate = nil
            sender.setTitle("Check Out", for: .normal)
            statusField.text = gameToShow?.status.rawValue
        }
    }
}
