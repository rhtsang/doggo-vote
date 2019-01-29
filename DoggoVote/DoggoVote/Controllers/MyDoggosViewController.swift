//
//  MyDoggosViewController.swift
//  DoggoVote
//
//  Created by Raymond Tsang on 11/15/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI

class MyDoggosViewController: UIViewController {

    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    var numDogs = 0
    
    @IBOutlet weak var myDoggosTableView: UITableView!
    
    // current user's UID
    let uid = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myDoggosTableView.register(UINib(nibName: "DoggoTableViewCell", bundle: nil), forCellReuseIdentifier: "doggoCell")
        myDoggosTableView.dataSource = self
        myDoggosTableView.rowHeight = 150
        getNumDogs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNumDogs()
        myDoggosTableView.reloadData()
    }
    
//https://hackernoon.com/swift-access-ios-camera-and-photo-library-dc1dbe0cdd76
    @IBAction func addDoggoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "MyDoggosToAddDoggosSegue", sender: self)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    
}

// MARK: Tableview extension
extension MyDoggosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numDogs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doggoCell") as! DoggoTableViewCell
        
        // get database reference to each of current user's dogs, based on value of indexpath.row
        let doggoInfo = databaseRef.child("all-users").child(uid).child("dogs").child("\(indexPath.row)")
        
        doggoInfo.observe(.value) { (snapshot) in
            guard let snapshot = snapshot.value as? Dictionary<String, String> else {
                return
            }
            
            let placeholderImage = UIImage(named: "first")
            let imageRef = self.storageRef.child(snapshot["filename"]!)
            
            // set UI fiels on UI thread based on values from database snapshot
            DispatchQueue.main.async {
                cell.doggoImageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
                cell.doggoName.text = snapshot["screenname"]
                cell.doggoPoints.text = snapshot["score"]
            }
        }
    
        return cell
    }
    
    func getNumDogs() {
        
        let currentUserDogs = databaseRef.child("all-users").child(uid).child("dogs")
        
        currentUserDogs.observeSingleEvent(of: .value) { (snapshot) in
            self.numDogs = Int(snapshot.childrenCount)
            self.myDoggosTableView.reloadData()
        }
    }
}
