//
//  FollowTableViewCell.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 3/6/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var userID: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
