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
    var caption: String?
    var photoUrl: String?
    init(captionText: String, photoUrlString: String) {
        caption = captionText
        photoUrl = photoUrlString
    }
}


