//
//  AddPostViewController.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 26/5/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Firebase


class EditPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var user = Auth.auth().currentUser!
    var data: NSData!
    var ref: DatabaseReference!
    var username = ""
    @IBOutlet weak var postingImage: UIImageView!
    var receivedImage : UIImage?
    
    @IBOutlet weak var descField: UITextField!
    @IBAction func AddPost(_ sender: Any) {
        uploadPhoto()
    }
    @IBAction func uploadPost(_ sender: Any) {
        uploadPost(data: data)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postingImage.image = receivedImage
        loadUser()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            image = resizeImage(image: image)
            data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL.absoluteURL.absoluteString)
            
            
            
            postingImage.image = image
            postingImage.contentMode = .scaleAspectFill
            
            
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    func uploadPhoto() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    func uploadPost(data: NSData){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let postRef = storageRef.child("posts/\(randomString(len: 25)).jpg")
        let uploadTask = postRef.putData(data as Data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            
            let downloadURL = metadata.downloadURL()?.absoluteString
            
            let key = self.ref.child("users").childByAutoId().key
            self.ref = Database.database().reference()
            
            self.ref.child("users/\(self.user.uid)/posts").child("post\(key)").setValue(["photo_url": downloadURL, "desc": self.descField.text, "username": self.username, "uid":self.user.uid, "likes": 0])
    
        }
        tabBarController?.selectedIndex = 0
        
    }
    func loadUser() {
        Database.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.username = value?["username"] as? String ?? ""

            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    //image compression
    func resizeImage(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0, y: 0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    func randomString(len:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for n in (1...10) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



