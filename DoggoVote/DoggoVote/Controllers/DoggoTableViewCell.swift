//
//  DoggoTableViewCell.swift
//  DoggoVote
//
//  Created by Raymond Tsang on 11/10/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit

class DoggoTableViewCell: UITableViewCell {

    @IBOutlet weak var doggoImageView: UIImageView!
    @IBOutlet weak var doggoName: UILabel!
    @IBOutlet weak var doggoPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
