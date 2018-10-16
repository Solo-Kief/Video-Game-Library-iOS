//  GameCell.swift
//  Video Game Library iOS
//
//  Created by Solomon Kieffer on 10/16/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit

class GameCell: UITableViewCell {
    @IBOutlet var titleField: UITextField!
    @IBOutlet var genreField: UITextField!
    @IBOutlet var ratingField: UITextField!
    @IBOutlet var statusField: UITextField!
    @IBOutlet var coverImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
