//
//  ProfileViewController.swift
//  Project
//
//  Created by Gianluca Lo Vecchio on 9/2/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    
    @IBAction func buttonLogOut(_ sender: Any) {
        try! Auth.auth().signOut()
let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.show(vc!, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
