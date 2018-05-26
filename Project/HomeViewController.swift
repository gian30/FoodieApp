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
    
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self as! UITableViewDataSource
        loadPosts()
        
        
        // Do any additional setup after loading the view.
    }
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
          
            if let dict = snapshot.value as? [String: Any] {
                let photoUrl = dict["photo_url"] as! String
                let descriptionText = dict["desc"] as! String
                
                let post = Post(descriptionText: descriptionText, photoUrlString: photoUrl)
                
                self.posts.append(post)
                print(self.posts)
                self.tableView.reloadData()
            }
        }
    }
  
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
       
        
        return cell
    }
}

