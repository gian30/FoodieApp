//
//  Post.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 24/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import Foundation
import FirebaseAuth
class Post {
    var description: String?
    var photo: UIImage?
    var username: String?
    var likes: Int
    init(descriptionText: String, photoData: UIImage, usernameText: String, likesNum: Int) {
        description = descriptionText
        photo = photoData
        username = usernameText
        likes = likesNum
    }
    
}



