//
//  LoginViewController.swift
//  DoggoVote
//
//  Created by Jess Nguyen on 11/29/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//  Also Sam was there
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // check if user exists already (if not create new user)
        // if yes authenticate
        
        errorLabel.isHidden = false
        
        if let email = emailField.text, let password = passwordField.text {
        
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                guard let _ = user else {
                    self.errorLabel.text = "login error"
                    return
                }

                //let s = Auth.auth().currentUser?.uid
                
                // move to next view controller
                self.performSegue(withIdentifier: "loginToTabController", sender: self)
            }
        
        }
        else {
            errorLabel.text = "email/password can't be empty"
        }
    }

    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        errorLabel.isHidden = false
        
        if let email = emailField.text, let password = passwordField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                guard let _ = result else {
                    self.errorLabel.text = "sign up error"
                    return
                }
                //var numUsers = 0
            
                var numUsers = 0
                let queue = DispatchQueue(label: "createUserQueue")
                queue.async {
                    let semaphore = DispatchSemaphore(value: 0)
                    DispatchQueue.global().async {
                        numUsers = self.getTotalNumUsers()
                        semaphore.signal()
                    }
                    semaphore.wait()
                    print(numUsers)
                    print(Auth.auth().currentUser!.uid)
                    let newUser = Database.database().reference().child("all-users").child(Auth.auth().currentUser!.uid)
                    newUser.child("user_index").setValue(numUsers)
                    //let _ = newUser.child("dogs")
                    //newUser.child("dogs").setValue("dogs go here")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginToTabController", sender: self)
                    }
                }
            }
            
        } else {
            errorLabel.text = "email/password can't be empty"
        }
        
    }
    
    func getTotalNumUsers() -> Int {
        var count: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        Database.database().reference().child("all-users").observe(DataEventType.value, with: { (snapshot) in
            //print("Count: \(snapshot.childrenCount)")
            count = Int(snapshot.childrenCount)
            semaphore.signal()
        })
        semaphore.wait()
        return count
    }
}
