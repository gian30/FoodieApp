//
//  HomeViewController.swift
//  Project
//
//  Created by Project on 25/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
 
    var followingUsers = [String]()
    var user = Auth.auth().currentUser!
    var posts = [Post]()
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self as! UITableViewDataSource
        self.tableView.addSubview(self.refreshControl)
        loadPosts()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        posts.removeAll()
        self.tableView.reloadData()
        loadPosts()
        refreshControl.endRefreshing()
    }
    func loadPosts() {
       // Database.database().reference().child("users/\(user.uid)").observe(.childAdded) { (snapshot: DataSnapshot) in
        
        ref.child("users").child(user.uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    self.followingUsers.append(value as! String)
                    self.ref.child("users/\(value)/posts").observe(.childAdded) { (snapshot: DataSnapshot) in
                        
                        if let dict = snapshot.value as? [String: Any] {
                            let photoUrl = dict["photo_url"] as! String
                            let descriptionText = dict["desc"] as! String
                            print(".........................")
                            print(photoUrl)
                            let username = dict["username"] as! String
                            let likes = dict["likes"] as! Int
                            let post = Post(descriptionText: descriptionText, photoData: photoUrl, usernameText: username, likesNum: likes)
                            self.posts.append(post)
                            self.tableView.reloadData()
                        }
                    }
                    
                }
            }
        })

    }
 
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(HomeViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.green
        
        return refreshControl
    }()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! HomeTableViewCell
        let post = posts[indexPath.row]
        
        cell.post = post
        cell.imagePost.image = nil
        cell.imagePost?.downloadImage(from: post.photo)
        
        
        return cell
    }
}



