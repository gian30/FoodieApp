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
    var photoUrl: String?
    init(descriptionText: String, photoUrlString: String) {
        description = descriptionText
        photoUrl = photoUrlString
    }
    
}



