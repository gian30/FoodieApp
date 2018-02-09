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
class ViewController: UIViewController, UIAlertViewDelegate {
    
    @IBAction func registerButton(_ sender: Any) {
        
  
        let alert = UIAlertController(title: "Nuevo Usuario",
                                      message: "Introduce tus datos por favor",
                                      preferredStyle: .alert)
  
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        //3.
                                        Auth.auth().createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                    self.goToCreateUserVC()
                                                                }
                                                                
                                        }
        }
      
        alert.addTextField { textEmail in
            textEmail.placeholder = "Email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Contraseña"
        }
        //6.
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
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
            
            
        }}
    func goToCreateUserVC(){
        performSegue(withIdentifier: "signUp", sender: nil)
    }
    func goToFeedVC(){
        performSegue(withIdentifier: "toFeed", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUp"{
            if let destination = segue.identifier as? UserVC {
                if uid != nil {
                    destination.uid = uid
                }
                if emailField.text != nil {
                    destination.emailField = emailField.text
                }
                if passwordField.text != nil{
                    destination.passwordField = passwordField.text
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.uid = user?.uid
                self.goToFeedVC()
            } else {
                // No user is signed in.
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

