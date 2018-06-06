//
//  FollowProfileViewController.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 2/6/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FollowProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self as UITableViewDataSource

        retrieveUsers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveUsers() {
        let ref = Database.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let userToShow = User()
                        if let fullname = value["fullname"] as? String, let imagePath = value["profile_photo"] as? String {
                            userToShow.fullName = fullname
                            userToShow.profileImageUrl = imagePath
                            userToShow.id = uid
                            self.user.append(userToShow)
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! FollowTableViewCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].id
        cell.userImage.layer.borderWidth = 1
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.borderColor = UIColor.black.cgColor
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
        cell.userImage.clipsToBounds = true
        cell.userImage.downloadImage(from: self.user[indexPath.row].profileImageUrl)
        checkFollowing(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let key = ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as! String == self.user[indexPath.row].id {
                        isFollower = true
                        
                        ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        ref.child("users").child(self.user[indexPath.row].id!).child("followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(key)" : self.user[indexPath.row].id]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("users").child(uid).updateChildValues(following)
                ref.child("users").child(self.user[indexPath.row].id!).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        ref.removeAllObservers()
        
    }
    func checkFollowing(indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as! String == self.user[indexPath.row].id {
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
        
    }
}


