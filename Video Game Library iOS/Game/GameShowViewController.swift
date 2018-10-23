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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var genreField: UITextField!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var ratingSelector: UISegmentedControl!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var checkInOut: UIButton!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var descriptionTopToStatusFieldConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionFieldBottomConstraint: NSLayoutConstraint!
    //Access to nearly every single object on the scrnee.
    
    let format = DateFormatter()
    //Used when outputting thendate.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustElements() //See bottom class.
        hideKeyboardWhenTappedAround() //See bottom class.
        format.dateStyle = .long //Format for the date.
        
        titleField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        genreField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        ratingSelector.addTarget(self, action: #selector(changeMade), for: .valueChanged)
        statusField.addTarget(self, action: #selector(changeMade), for: .editingChanged)
        //See textViewDidChange()
        
        ratingSelector.layer.cornerRadius = 20.0
        ratingSelector.layer.borderColor = editButton.tintColor.cgColor
        ratingSelector.layer.borderWidth = 1.0
        ratingSelector.layer.masksToBounds = true
        coverImageView.layer.borderColor = UIColor.gray.cgColor
        coverImageView.layer.borderWidth = 3
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
        //Extra UI customizations.
        
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
        //Puts the data in the text fields.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeMade()
    } //Function granted to textView Delegates.
      //Called if the textView expereinces user initiated changes
    
    @objc func changeMade() { //Used by text fields to notify if a change was made.
        changeWasMade = true
    } //Used by the end editing warning.
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    } //It's what the back button does.
    
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
    } //Pretty self explanitory.
    
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
                }) //Updates the necisary game data from the edited text fields.
                
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
            Game.refreshArray()
        }
    } //Ok, so this one actually does a lot. If the app isn't in editing mode, the 'if' part of this statement will do the
      //necisary changes to make users be able to edit games. The 'else' part will say, if it is alreay in edit mode, it'll
      //put the app back in it's original state and IF a change was made, it'll bring up an alert asking if they want to
      //keep changes made.
    
    @objc func redistributeElements() { //See Bottom of GameAddView Controller
        if descriptionField.isEditable {
            titleLabel.isHidden = true
            titleField.isHidden = true
            genreLabel.isHidden = true
            genreField.isHidden = true
            ratingLabel.isHidden = true
            ratingSelector.isHidden = true
            editButton.isHidden = true
            descriptionTopToStatusFieldConstraint.constant = -320
            descriptionFieldBottomConstraint.constant = 304
            self.descriptionField.becomeFirstResponder()
        }
    }
    
    @objc func resetElements() { //See Bottom of GameAddView Controller
        titleLabel.isHidden = false
        titleField.isHidden = false
        genreLabel.isHidden = false
        genreField.isHidden = false
        ratingLabel.isHidden = false
        ratingSelector.isHidden = false
        editButton.isHidden = false //Prevents leaving edit mode while elements are misaligned. Easier than trying to compensate for two different scenarios. In short: I'm a cop-out.
        descriptionTopToStatusFieldConstraint.constant = -66
        descriptionFieldBottomConstraint.constant = 0
    }
}

//This class also uses UIViewController extension at bottom.

//Copy of GameAddViewController extenstion at bottom.
extension GameShowViewController {
    override func dismissKeyboard() {
        resetElements()
        super.dismissKeyboard()
    }
    
    func adjustElements() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameAddViewController.redistributeElements))
        tap.cancelsTouchesInView = false
        descriptionField.addGestureRecognizer(tap)
    }
}

//Graphical glitches and UI Missalignment can occur if someone hits the description field very
//quickly after hitting the end edit button. Unsure of how to fix.


///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

class GameAddViewController: UIViewController {
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
    //Used by graphical functions later.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustElements() //Order of these two commands matters.
        hideKeyboardWhenTappedAround() //See these functions
        
        defaultColor = addGameButton.backgroundColor!
        
        ratingControl.layer.cornerRadius = 20.0
        ratingControl.layer.borderColor = addGameButton.tintColor.cgColor
        ratingControl.layer.borderWidth = 1.0
        ratingControl.layer.masksToBounds = true
        coverImageView.layer.borderColor = UIColor.gray.cgColor
        coverImageView.layer.borderWidth = 3
        coverImageView.layer.cornerRadius = 5
        coverImageView.layer.masksToBounds = true
        //Graphical customizations
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    } //Does what is says it does.
    
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
        } //Uses the rating selector to set the game rating.
        
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
        } //Adds game if it has a title, genre, and rating. Uses some included animation if requirements not met.
        
        Game.gameList.append(Game(title: titleField.text!, genre: genreField.text!, rating: rating, description: descriptionField.text)) //Adds the game to the array.
        Game.refreshArray() //Refreshes the game array by saving and reloading the array.
        
        titleField.text = ""
        genreField.text = ""
        descriptionField.text = ""
        ratingControl.selectedSegmentIndex = -1
        //Resets the fields to empty.
    }
    
    @objc func restoreSubmitButton() {
        UIView.animate(withDuration: 0.25, animations: {
            self.addGameButton.setTitle("Add Game", for: .normal)
            self.addGameButton.backgroundColor = self.defaultColor
            })
    } //Used to restore the submit button to original state.
    
    @objc func redistributeElements() { //Moves screen elements in order to bring the description text
        self.titleLabel.isHidden = true //field back into view when the keyboard is brought up.
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
} //Adding the hideKeyboardWhenTappedAround() function will cause the keyboard to resign when tapped off of.

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
} //This extension essintially layers another tap recognizer on top of the one from the UIViewController extnesion
  //to allow the description to recognize taps, and move itself back and forth when it is being edited.
