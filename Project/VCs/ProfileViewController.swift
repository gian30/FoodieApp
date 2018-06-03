//
//  ProfileViewController.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 9/2/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import QuartzCore
class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var posts = [Post]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user = Auth.auth().currentUser!
    @IBAction func buttonLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.show(vc!, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self as! UICollectionViewDataSource
        loadPosts()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPosts() {
        Database.database().reference().child("users/\(user.uid)/posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let photoUrl = dict["photo_url"] as! String
                let descriptionText = dict["desc"] as! String
                let username = dict["username"] as! String
                let likes = dict["likes"] as! Int
                
                let url = URL(string: (photoUrl))
                let data = try? Data(contentsOf: url!)
                
                let post = Post(descriptionText: descriptionText, photoData: photoUrl, usernameText: username, likesNum: likes)
                self.posts.append(post) 
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        let post = posts[indexPath.row]
        
        cell.thumbImageView.downloadImage(from: post.photo)
        
        
        return cell
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}




