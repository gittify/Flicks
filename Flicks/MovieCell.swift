//
//  MovieCell.swift
//  Flicks
//
//  Created by Doshi, Nehal on 4/1/17.
//  Copyright © 2017 Doshi, Nehal. All rights reserved.
//

import UIKit
import Foundation

class MovieCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
