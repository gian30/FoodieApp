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
import Photos

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /*var user = Auth.auth().currentUser;
     var data: NSData!
     var ref: DatabaseReference!
     @IBOutlet weak var imageView: UIImageView!
     
     @IBOutlet weak var descField: UITextField!
     @IBAction func AddPost(_ sender: Any) {
     uploadPhoto()
     }
     @IBAction func uploadPost(_ sender: Any) {
     uploadPost(data: data)
     }
     */
    @IBOutlet fileprivate var captureButton: UIButton!
    
    @IBOutlet weak var imageview: UIImageView!
    ///Displays a preview of the video output generated by the device's cameras.
    @IBOutlet fileprivate var capturePreviewView: UIView!
    
    ///Allows the user to put the camera in photo mode.
    @IBOutlet fileprivate var photoModeButton: UIButton!
    @IBOutlet fileprivate var toggleCameraButton: UIButton!
    @IBOutlet fileprivate var toggleFlashButton: UIButton!
    
    ///Allows the user to put the camera in video mode.
    @IBOutlet fileprivate var videoModeButton: UIButton!
    
    let cameraController = CameraController()
    
    override var prefersStatusBarHidden: Bool { return true }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        imageview.isHidden = true
        func configureCameraController() {
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.capturePreviewView)
            }
        }


        func styleCaptureButton() {
            //captureButton.layer.borderColor = UIColor.black.cgColor
            //captureButton.layer.borderWidth = 2
            
            //captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
        
    }
    @IBAction func toggleFlash(_ sender: UIButton) {
        if cameraController.flashMode == .on {
            cameraController.flashMode = .off
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
            
        else {
            cameraController.flashMode = .on
            toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    @IBAction func switchCameras(_ sender: UIButton) {
        do {
            try cameraController.switchCameras()
        }
            
        catch {
            print(error)
        }
        
        switch cameraController.currentCameraPosition {
        case .some(.front):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
            
        case .some(.rear):
            toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        case .none:
            return
        }
    }
    
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
                
            }
            self.imageview.image = image
            self.imageview.isHidden = false
        }
        //tabBarController?.selectedIndex = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
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
     func uploadPost(data: NSData){
     let storage = Storage.storage()
     let storageRef = storage.reference()
     let postRef = storageRef.child("posts/\(randomString(len: 25)).jpg")
     let uploadTask = postRef.putData(data as Data, metadata: nil) { (metadata, error) in
     guard let metadata = metadata else {
     return
     }
     
     let downloadURL = metadata.downloadURL()?.absoluteString
     
     
     self.ref = Database.database().reference()
     self.ref.child("posts").child("post\(self.randomString(len: 25))").setValue(["photo_url": downloadURL, "desc": self.descField.text, "username":self.user?.email, "likes": 0])
     }
     self.goToFeedVC()
     }
     func goToFeedVC(){
     performSegue(withIdentifier: "goToFeed", sender: nil)
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
     */
}


