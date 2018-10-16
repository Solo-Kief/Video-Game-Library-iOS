//
//  GameShowViewController.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import UIKit

class GameShowViewController: UIViewController {
    //Sent by the initial view controller.
    var gameToShow: Game?
    @IBOutlet var titleField: UITextField!
    @IBOutlet var genraField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = gameToShow?.title
        genraField.text = gameToShow?.genra
        ratingField.text = gameToShow?.rating.rawValue
        if gameToShow?.status == Game.Status.checkedOut {
        statusField.text = "\(gameToShow?.status.rawValue ?? "Something is wrong.") \(gameToShow?.dueDate ?? Date())"
        } else {
            statusField.text = gameToShow?.status.rawValue
        }
        descriptionField.text = gameToShow?.description
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
