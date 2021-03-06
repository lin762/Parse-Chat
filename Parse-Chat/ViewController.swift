//
//  ViewController.swift
//  Parse-Chat
//
//  Created by Chris lin on 1/31/18.
//  Copyright © 2018 Chris lin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    let usernameAlertController = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
    let passwordAlertController = UIAlertController(title: "Error", message: "Please enter a password", preferredStyle: .alert)
    let credentialAlertController = UIAlertController(title: "Error", message: "Incorrect password or username", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        usernameAlertController.addAction(OKAction)
        passwordAlertController.addAction(OKAction)
        credentialAlertController.addAction(OKAction)
    }

    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        // set user properties
        if (usernameField.text?.isEmpty)!{
            present(usernameAlertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }else{
            newUser.username = usernameField.text
        }
        //newUser.email = emailLabel.text
        if (passwordField.text?.isEmpty)!{
            present(passwordAlertController, animated: true) {
                // optional code for what happens after the alert controller has finished presenting
            }
        }else{
            newUser.password = passwordField.text
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let newUser = PFUser()
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        if (username.isEmpty){
            present(usernameAlertController, animated: true) {
               
            }
        }else{
            newUser.username = username
        }
        //newUser.email = emailLabel.text
        if (password.isEmpty){
            present(passwordAlertController, animated: true) {
                
            }
        }else{
            newUser.password = password
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.present(self.credentialAlertController, animated: true) {
                    
                }
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        // handle response here.
    }
    // add the OK action to the alert controller
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

