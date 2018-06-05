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
    
    @IBOutlet weak var profilePhoto: UIImageView!

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var follows: UILabel!
    @IBOutlet weak var usernameLabel: UINavigationItem!
    var user = Auth.auth().currentUser!
    @IBAction func buttonLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.show(vc!, sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         loadUser()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()
        collectionView.dataSource = self as! UICollectionViewDataSource
        //profilePhoto.downloadImage(from: user.photoURL as? String)
        //print(user.profileImageUrl as? String!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: width / 3, height: width / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        
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
                let uid = dict["uid"] as! String
                let url = URL(string: (photoUrl))
                let data = try? Data(contentsOf: url!)
                
                let post = Post(descriptionText: descriptionText, photoData: photoUrl, usernameText: username, likesNum: likes, uidU : uid)
                self.posts.append(post) 
                self.collectionView.reloadData()
            }
        }
    }
    func loadUser() {
        Database.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            let fullname = value?["fullname"] as? String ?? ""
            let photoUrl = value?["profile_photo"] as? String ?? ""
            self.profilePhoto.downloadImage(from: photoUrl)
            self.fullnameLabel.text = fullname
            self.usernameLabel.title = username
            
        }) { (error) in
            print(error.localizedDescription)
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
    
    
}



