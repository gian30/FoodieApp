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
        self.goToCreateUserVC()
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
                        let alertView = UIAlertView(title: "Contraseña incorrecta", message: "La contraseña que has escrito no es correcta. Vuelve a intentarlo.", delegate: self as! UIAlertViewDelegate, cancelButtonTitle: "Volver a intentarlo")
                        
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

