//
//  HomeTableViewCell.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 25/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import SDWebImage
class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionPost: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var imagePost: UIImageView!

    @IBOutlet weak var heightPhoto: NSLayoutConstraint!
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    
    func updateView() {
        descriptionPost.text = post?.description
        
        
        imagePost.image = post?.photo
    }
    
    var user: User? {
        didSet {
            //setupUserInfo()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
