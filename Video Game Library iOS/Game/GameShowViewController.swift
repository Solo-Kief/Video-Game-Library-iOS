//
//  GameShowViewController.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.
//

import UIKit

class GameShowViewController: UIViewController, UITextViewDelegate {
    var gameSelector: Int?
    var changeWasMade = false
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var genreField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var ratingSelector: UISegmentedControl!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var checkInOut: UIButton!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var descriptionTopToStatusFieldConstraint: NSLayoutConstraint!
    
    let format = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        format.dateStyle = .long
        
        titleField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        genreField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        ratingSelector.addTarget(self, action: #selector(changeMade), for: .valueChanged)
        statusField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        //See textViewDidChange
        
        ratingSelector.layer.cornerRadius = 20.0
        ratingSelector.layer.borderColor = editButton.tintColor.cgColor
        ratingSelector.layer.borderWidth = 1.0
        ratingSelector.layer.masksToBounds = true
        coverImageView.layer.borderColor = UIColor.gray.cgColor
        coverImageView.layer.borderWidth = 3
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
        
        titleField.text = Game.gameList[gameSelector!].title
        genreField.text = Game.gameList[gameSelector!].genre
        ratingField.text = Game.gameList[gameSelector!].rating.rawValue
        if Game.gameList[gameSelector!].status == .checkedOut {
            statusField.text = "\(Game.gameList[gameSelector!].status.rawValue) - Due: \(format.string(from: (Game.gameList[gameSelector!].dueDate)!))"
            checkInOut.setTitle("Check In", for: .normal)
        } else {
            statusField.text = Game.gameList[gameSelector!].status.rawValue
        }
        descriptionField.text = Game.gameList[gameSelector!].Description
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeMade()
    } //Function granted to textView Delegates.
      //Called if the textView expereinces user initiated changes
    
    @objc func changeMade() { //Used by text fields to notify if a change was made.
        changeWasMade = true
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkInOut(_ sender: UIButton) {
        if Game.gameList[gameSelector!].status == .checkedIn {
            Game.gameList[gameSelector!].status = .checkedOut
            Game.gameList[gameSelector!].dueDate = Date().addingTimeInterval(1209600)
            sender.setTitle("Check In", for: .normal)
            statusField.text = "\(Game.gameList[gameSelector!].status.rawValue) - Due:  \(format.string(from: (Game.gameList[gameSelector!].dueDate)!))"
        } else {
            Game.gameList[gameSelector!].status = .checkedIn
            Game.gameList[gameSelector!].dueDate = nil
            sender.setTitle("Check Out", for: .normal)
            statusField.text = Game.gameList[gameSelector!].status.rawValue
        }
        
        Game.refreshArray()
    }
    
    @IBAction func editToggle(_ sender: UIButton) {
        if !titleField.isUserInteractionEnabled {
            editButton.setTitle("End Editing", for: .normal)
            titleField.isUserInteractionEnabled = true
            genreField.isUserInteractionEnabled = true
            ratingField.isHidden = true
            ratingSelector.isHidden = false
            ratingSelector.isUserInteractionEnabled = true
            switch Game.gameList[gameSelector!].rating {
            case .E:
                ratingSelector.selectedSegmentIndex = 0
            case .E10:
                ratingSelector.selectedSegmentIndex = 1
            case .T:
                ratingSelector.selectedSegmentIndex = 2
            case .M:
                ratingSelector.selectedSegmentIndex = 3
            case .AO:
                ratingSelector.selectedSegmentIndex = 4
            }
            statusLabel.isHidden = true
            statusField.isHidden = true
            descriptionField.isEditable = true
            descriptionTopToStatusFieldConstraint.constant = -66
        } else {
            if changeWasMade {
                let alert = UIAlertController(title: "Keep Changes?", message: "You have made changes to the current game. Would you like to keep them?", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Discard", style: .cancel, handler: {action in
                    self.titleField.text = Game.gameList[self.gameSelector!].title
                    self.genreField.text = Game.gameList[self.gameSelector!].genre
                    self.ratingField.text = Game.gameList[self.gameSelector!].rating.rawValue
                    if Game.gameList[self.gameSelector!].status == .checkedOut {
                        self.statusField.text = "\(Game.gameList[self.gameSelector!].status.rawValue) - Due: \(self.format.string(from: (Game.gameList[self.gameSelector!].dueDate)!))"
                        self.checkInOut.setTitle("Check In", for: .normal)
                    } else {
                        self.statusField.text = Game.gameList[self.gameSelector!].status.rawValue
                    }
                    self.descriptionField.text = Game.gameList[self.gameSelector!].Description
                }) //Cancel action refreshes the games data to original state.

                let changeAction = UIAlertAction(title: "Keep", style: .destructive, handler: {action in
                    Game.gameList[self.gameSelector!].title = self.titleField.text!
                    Game.gameList[self.gameSelector!].genre = self.genreField.text!
                    switch self.ratingSelector.selectedSegmentIndex {
                    case 0:
                        Game.gameList[self.gameSelector!].rating = .E
                    case 1:
                        Game.gameList[self.gameSelector!].rating = .E10
                    case 2:
                        Game.gameList[self.gameSelector!].rating = .T
                    case 3:
                        Game.gameList[self.gameSelector!].rating = .M
                    case 4:
                        Game.gameList[self.gameSelector!].rating = .AO
                    default:
                        Game.gameList[self.gameSelector!].rating = .E
                    }
                    Game.gameList[self.gameSelector!].Description = self.descriptionField.text
                    
                    self.ratingField.text = Game.gameList[self.gameSelector!].rating.rawValue
                    Game.refreshArray()
                })
                
                alert.addAction(cancelAction)
                alert.addAction(changeAction)
                
                self.present(alert, animated: true)
            }
            
            //Code to reset screen to original state.
            editButton.setTitle("Edit", for: .normal)
            titleField.isUserInteractionEnabled = false
            genreField.isUserInteractionEnabled = false
            ratingField.isHidden = false
            ratingSelector.isHidden = true
            ratingSelector.isUserInteractionEnabled = false
            statusLabel.isHidden = false
            statusField.isHidden = false
            descriptionField.isEditable = false
            descriptionTopToStatusFieldConstraint.constant = 8
            changeWasMade = false
            //Update Game List
            Game.refreshArray()
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

class GameAddViewController: UIViewController {
    var gameToShow: Int?
    
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
        
        Game.gameList.append(Game(title: titleField.text!, genre: genreField.text!, rating: rating, description: descriptionField.text))
        Game.refreshArray()
        
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
        self.titleLabel.isHidden = true //back into view when the keyboard is brought up.
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
