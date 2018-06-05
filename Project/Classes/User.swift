//
//  User.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 24/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import Foundation
class User {
    var email: String?
    var profileImageUrl: String?
    var fullName: String?
    var username: String?
    
    
    var id: String?
    var isFollowing: Bool?
}

extension User {
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profile_photo"] as? String
        user.fullName = dict["fullname"] as? String
        user.username = dict["username"] as? String
        user.id = key
        
        return user
    }
}

