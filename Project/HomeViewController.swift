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
        tableView.dataSource = self as? UITableViewDataSource
        loadPosts()
        var post = Post(captionText: "test", photoUrlString: "url1")
        print(post.caption!)
        print(post.photoUrl!)
        
        // Do any additional setup after loading the view.
    }
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(snapshot.value)
            if let dict = snapshot.value as? [String: Any] {
                let photoUrl = dict["photo_url"] as! String
                let captionText = dict["desc"] as! String
                
                let post = Post(captionText: captionText, photoUrlString: photoUrl)
                
                self.posts.append(post)
                print(dict)
            }
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.red
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

