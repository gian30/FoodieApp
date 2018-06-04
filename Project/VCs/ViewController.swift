//
//  ViewController.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 6/2/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ViewController: UIViewController, UIAlertViewDelegate {
    var errorLogIn: Bool = false
    var ref: DatabaseReference!
    var defaultPhoto = "https://firebasestorage.googleapis.com/v0/b/project-218c7.appspot.com/o/Profile_Selected%403x.png?alt=media&token=e538743e-aaac-44ff-8002-97ea923df569ç"
    @IBAction func registerButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Nuevo Usuario",
                                      message: "Introduce tus datos por favor",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Registrar",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        let usernameField = alert.textFields![2]
                                        let fullnameField = alert.textFields![3]
                                        //3.
                                        Auth.auth().createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                    user?.uid
                                                                    
                                                                    self.ref = Database.database().reference()
                                                                    self.ref.child("users").child((user?.uid)!).setValue([ "profile_photo": self.defaultPhoto, "email": user?.email, "username": usernameField.text!, "fullname": fullnameField.text!, "uid": user?.uid])
                                                                    self.goToFeedVC()
                                                                }
                                        }
        }
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Contraseña"
        }
        alert.addTextField { textUsername in
            textUsername.placeholder = "Nombre de usuario"
        }
        alert.addTextField { textFullname in
            textFullname.placeholder = "Nombre completo"
        }
        //6.
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        //7.
        present(alert, animated: true, completion: nil)
        
        
        
    }
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var uid: String!
    @IBAction func signInTapped(_ sender: Any) {
        if let email = self.emailField.text, let password = self.passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    self.errorLogIn = false
                    if let user = user {
                        self.uid = user.uid
                        self.goToFeedVC()
                    }
                }else{
                    
                    let alertView = UIAlertView(title: "Contraseña incorrecta", message: "La contraseña que has escrito no es correcta. Vuelve a intentarlo.", delegate: self as UIAlertViewDelegate, cancelButtonTitle: "Volver a intentarlo")
                    
                    // Configure Alert View
                    alertView.tag = 1
                    
                    // Show Alert View
                    alertView.show()
                }
            }
        }
    }
    
    
    func goToFeedVC(){
        performSegue(withIdentifier: "toFeed", sender: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.goToFeedVC()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

