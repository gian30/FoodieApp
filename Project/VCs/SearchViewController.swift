//
//  SearchViewController.swift
//  Project
//
//  Created by DAM on 4/6/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import QuartzCore

class SearchViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    
    var user = Auth.auth().currentUser!
    var posts = [Post]()
    var filteredPosts = [Post]()
    
    
    
    
    @IBOutlet weak var GaleriaImagenes: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GaleriaImagenes.delegate = self as UICollectionViewDelegate
        GaleriaImagenes.dataSource = self as UICollectionViewDataSource
        loadPosts()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Buscar aqui"
        sb.barTintColor = .gray
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String){
        self.GaleriaImagenes.reloadData()
        if searchText.isEmpty{
            self.filteredPosts = self.posts
        } else {
            self.filteredPosts = self.posts.filter({(posts) -> Bool in
                return (posts.photo != nil)
            })
        }
        self.GaleriaImagenes.reloadData()
    }
    
    
    /*func filter( searchTerm: String){
     
     }
     
     func object(at indexPath: IndexPath) -> IndexPath {
     if isFiltering {
     return filteredObjects[indexPath.item]
     } else {
     return posts[indexPath.item]
     }
     }*/
    
    func loadPosts() {
        Database.database().reference().child("users/\(user.uid)/posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                let photoUrl = dict["photo_url"] as! String
                let descriptionText = dict["desc"] as! String
                let username = dict["username"] as! String
                let likes = dict["likes"] as! Int
                
                let url = URL(string: (photoUrl))
                let data = try? Data(contentsOf: url!)
                
                let post = Post(descriptionText: descriptionText, photoData: photoUrl, usernameText: username, likesNum: likes, uidU: self.user.uid)
                self.posts.append(post)
                
                self.GaleriaImagenes.reloadData()
            }
        }
    }
    
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
        let post = posts[indexPath.row]
        
        cell.searchImageView.downloadImage(from: post.photo)
        
        
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
