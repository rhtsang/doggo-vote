//
//  SecondViewController.swift
//  DoggoVote
//
//  Created by Raymond Tsang on 11/10/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TopDoggosViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var topDoggosTableView: UITableView!
    
    // fetch top dogs ("fetch" heh heh heh)
    let topTable = Database.database().reference().child("topDoggos")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView init
        topDoggosTableView.register(UINib(nibName: "DoggoTableViewCell", bundle: nil), forCellReuseIdentifier: "doggoCell")
        topDoggosTableView.rowHeight = 150
        topDoggosTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load data
        topDoggosTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // prepare 5 cells
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doggoCell") as! DoggoTableViewCell

        let sem = DispatchSemaphore(value: 0)
        let q = DispatchQueue(label: "tableAccess")
        
        q.async{
            // retrieve info from topDoggos table
            var userID : String = "<not set>"
            var dogNum : String = "<not set>"
            Database.database().reference().child("topDoggos").observeSingleEvent(of: .value)
            { (snapshot) in
                let value = snapshot.value as! NSArray
                let dogStr = value[indexPath.row] as! String
                userID = String(dogStr.prefix(dogStr.count - 1))
                dogNum = String(dogStr.suffix(1))
                sem.signal()
            }
            
            // retrieve info from all-users table
            sem.wait()
            var filename : String = "<not set>"
            var score : String = "<not set>"
            var screenname : String = "<not set>"
            Database.database().reference().child("all-users").child(userID).child("dogs").child(dogNum).observeSingleEvent(of: .value){ (snapshot) in
                let dog = snapshot.value as! Dictionary<String, String>

                filename = dog["filename"]!
                score = dog["score"]!
                screenname = dog["screenname"]!
                sem.signal()
            }
            
            // retrieve picture from storage and set cell data
            sem.wait()
            DispatchQueue.main.async {
                cell.doggoName.text = screenname
                cell.doggoPoints.text = "\(score) points"
                
                Storage.storage().reference(withPath: filename).getData(maxSize: 1 * 1024 * 1024) {data,error in
                    if error == nil {
                        cell.doggoImageView.image = UIImage(data: data!)
                    } // if download fires without issue
                } // attempt download
                
            } // change UI in main thread
        }

        return cell
    }
    
}

