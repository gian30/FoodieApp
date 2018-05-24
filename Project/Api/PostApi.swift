//
//  PostApi.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 24/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PostApi {
    var REF_POSTS = Database.database().reference().child("posts")
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping (Post) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: DataEventType.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let post = Post.transformPostPhoto(dict: dict, key: snapshot.key)
                completion(post)
            }
        })
    }
    
    func observeLikeCount(withPostId id: String, completion: @escaping (Int, UInt) -> Void) {
        var likeHandler: UInt!
        likeHandler = REF_POSTS.child(id).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                //  FIRDatabase.database().reference().removeObserver(withHandle: ref)
                completion(value, likeHandler)
            }
        })
        
    }
    
    func observeTopPosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value, with: {
            snapshot in
            let arraySnapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            arraySnapshot.forEach({ (child) in
                if let dict = child.value as? [String: Any] {
                    let post = Post.transformPostPhoto(dict: dict, key: child.key)
                    completion(post)
                }
            })
        })
    }
    
    func removeObserveLikeCount(id: String, likeHandler: UInt) {
        Api.Post.REF_POSTS.child(id).removeObserver(withHandle: likeHandler)
    }
    

    
    
    
    
}

