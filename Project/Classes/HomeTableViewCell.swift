//
//  HomeTableViewCell.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 25/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionPost: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    var imageToShow : UIImageView!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likes: UIButton!
    @IBOutlet weak var heightPhoto: NSLayoutConstraint!
    var post: Post! {
        didSet {
            
            updateView()
        }
    }
    
    var doubleTap : Bool! = false
    
    @IBOutlet weak var likeimg: UIButton!
    @IBAction func like(_ sender: Any) {
        if (doubleTap) {
            doubleTap = false
            likeimg.setBackgroundImage(UIImage(named: "like") as? UIImage, for: UIControlState.normal)
            
            post.likes = (post.likes) - 1
            if post.likes == 0 {
                likes.setTitle("Be the first to like this", for: UIControlState.normal)
            }else{
                likes.setTitle(String((post.likes)), for: UIControlState.normal)
            }
        }else {
            doubleTap = true
            likeimg.setBackgroundImage(UIImage(named: "likeSelected"), for: UIControlState.normal)
            post.likes = (post.likes) + 1
            likes.setTitle(String((post.likes)), for: UIControlState.normal)
        }
    }
    func updateView() {
        descriptionPost.text = post?.description
        username.text = post?.username
        likes.setTitle(String(describing: post.likes), for: UIControlState.normal)
        if post.likes == 0 {
            likes.setTitle("Be the first to like this", for: UIControlState.normal)
            likeimg.setBackgroundImage(UIImage(named: "like"), for: UIControlState.normal)
        }
        
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

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}
