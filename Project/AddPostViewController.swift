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
class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var ref: DatabaseReference!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func AddPost(_ sender: Any) {
        uploadPhoto()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            print(photoURL.absoluteURL.absoluteString)
            
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let riversRef = storageRef.child("Users/username/\(randomString(len: 25)).jpg")
            let uploadTask = riversRef.putData(data as Data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                
                let downloadURL = metadata.downloadURL()?.absoluteString
                
                
                self.ref = Database.database().reference()
                self.ref.child("posts").child("post\(self.randomString(len: 25))").setValue(["photo_url": downloadURL, "desc": "test"])
            }
            
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        
        
     
        dismiss(animated: true, completion: nil)
    }
    func uploadPhoto() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
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
    
}


