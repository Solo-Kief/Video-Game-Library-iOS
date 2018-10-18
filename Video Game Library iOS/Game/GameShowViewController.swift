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
    @IBOutlet var genreField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var checkInOut: UIButton!
    @IBOutlet var coverImageView: UIImageView!
    
    let format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        format.dateStyle = .medium
        
        coverImageView.layer.borderColor = UIColor.gray.cgColor
        coverImageView.layer.borderWidth = 3
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
        
        //Delete Me
        if gameToShow?.title == "Overwatch" {
            coverImageView.image = #imageLiteral(resourceName: "Boxart_overwatch")
        } else if gameToShow?.title == "Team Fortress 2" {
            coverImageView.image = #imageLiteral(resourceName: "Tf2_standalonebox")
        }
        //
        
        titleField.text = gameToShow?.title
        genreField.text = gameToShow?.genre
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

///////////////////

class GameAddViewController: UIViewController {
    var gameToShow: Game?
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var genreField: UITextField!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var ratingControl: UISegmentedControl!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var addGameButton: UIButton!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var descriptionFieldToRatingControlConstraint: NSLayoutConstraint!
    
    var defaultColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustElements()
        hideKeyboardWhenTappedAround()
        
        defaultColor = addGameButton.backgroundColor!
        
        ratingControl.layer.cornerRadius = 20.0
        ratingControl.layer.borderColor = addGameButton.tintColor.cgColor
        ratingControl.layer.borderWidth = 1.0
        ratingControl.layer.masksToBounds = true
        coverImageView.layer.borderColor = UIColor.gray.cgColor
        coverImageView.layer.borderWidth = 3
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createGame(_ sender: Any) {
        let rating: Game.Rating
        switch ratingControl.selectedSegmentIndex {
        case 0:
            rating = .E
        case 1:
            rating = .E10
        case 2:
            rating = .T
        case 3:
            rating = .M
        case 4:
            rating = .AO
        default:
            rating = .E
        }
        
        guard titleField.text != "" && genreField.text != "", ratingControl.selectedSegmentIndex != -1 else {
            if titleField.text == "" {
                UIView.animate(withDuration: 0.25, animations: {
                    self.addGameButton.setTitle("A Title Must Be Given", for: .normal)
                    self.addGameButton.backgroundColor = UIColor.red
                })
            } else if genreField.text == "" {
                UIView.animate(withDuration: 0.25, animations: {
                    self.addGameButton.setTitle("A Genra Must Be Given", for: .normal)
                    self.addGameButton.backgroundColor = UIColor.red
                })
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.addGameButton.setTitle("A Rating Must Be Set", for: .normal)
                    self.addGameButton.backgroundColor = UIColor.red
                })
            }
            
            let timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(restoreSubmitButton), userInfo: nil, repeats: false)
            timer.fireDate = Date().addingTimeInterval(3)
            
            return
        }
        
        Game(title: titleField.text!, genre: genreField.text!, rating: rating, description: descriptionField.text)
        
        titleField.text = ""
        genreField.text = ""
        descriptionField.text = ""
        ratingControl.selectedSegmentIndex = -1
    }
    
    @objc func restoreSubmitButton() {
        UIView.animate(withDuration: 0.25, animations: {
            self.addGameButton.setTitle("Add Game", for: .normal)
            self.addGameButton.backgroundColor = self.defaultColor
            })
    }
    
    @objc func redistributeElements() { //Moves screen elements in order to bring the description
        self.titleLabel.isHidden = true //back into view when the keyboard is brough up.
        self.titleField.isHidden = true
        self.genreLabel.isHidden = true
        self.genreField.isHidden = true
        self.ratingLabel.isHidden = true
        self.ratingControl.isHidden = true
        self.descriptionFieldToRatingControlConstraint.constant = -230
        self.descriptionField.becomeFirstResponder()
    }
    
    @objc func resetElements() { //Returns those elements back to their original state.
        self.titleLabel.isHidden = false
        self.titleField.isHidden = false
        self.genreLabel.isHidden = false
        self.genreField.isHidden = false
        self.ratingLabel.isHidden = false
        self.ratingControl.isHidden = false
        self.descriptionFieldToRatingControlConstraint.constant = 8
    }
}

extension UIViewController { //Primary recognizer that any ViewController can use.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension GameAddViewController {
    override func dismissKeyboard() { //This class overrides this function in order to allow both
        resetElements()               //functions being run instead of just the one.
        super.dismissKeyboard()
    }
    
    func adjustElements() { //This recognizer is layered on top of the first one by using a seperate class.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameAddViewController.redistributeElements))
        tap.cancelsTouchesInView = false
        descriptionField.addGestureRecognizer(tap)
    } //Attached to the description field in order to target the field and not happen any other time.
}
