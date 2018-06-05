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
    var photo: String?
    var username: String?
    var likes: Int
    var uidUser: String?
    init(descriptionText: String, photoData: String, usernameText: String, likesNum: Int, uidU: String) {
        description = descriptionText
        photo = photoData
        username = usernameText
        likes = likesNum
        uidUser = uidU
    }
    
}



