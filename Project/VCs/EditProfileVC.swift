//
//  EditProfileVC.swift
//  Project
//
//  Created by Hector Blanco Felipe on 1/6/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var user = Auth.auth().currentUser!
    var data: NSData!
   
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBOutlet weak var nameLAbel: UITextField!
    
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBAction func saveData(_ sender: Any) {
        self.ref = Database.database().reference()
        
        let alert = UIAlertController(title: "Guardar", message: "Cambios Guardados!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
       
        
        var show = true
        if nameLAbel.text != ""{
            self.ref.child("users/\(self.user.uid)/fullname").setValue(nameLAbel.text)
            self.present(alert, animated: true, completion: nil)
            show = false
        }
        if usernameLabel.text != ""{
            self.ref.child("users/\(self.user.uid)/username").setValue(usernameLabel.text)
            if show == true{
                self.present(alert, animated: true, completion: nil)
            }
        }
        tabBarController?.selectedIndex = 5
    }
    
    
    
    @IBAction func AddProfilePhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            
            data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)

            let photoURL = URL.init(fileURLWithPath: localPath!)
         
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let postRef = storageRef.child("userphotos/\(user.uid).jpg")
            let uploadTask = postRef.putData(data as Data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                
                let downloadURL = metadata.downloadURL()?.absoluteString
                
                
                self.ref = Database.database().reference()
                self.ref.child("users/\(self.user.uid)/profile_photo").setValue(downloadURL)
                
               
                
            }
            
            
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    


}
