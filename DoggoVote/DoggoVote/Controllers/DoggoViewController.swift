//
//  FirstViewController.swift
//  DoggoVote
//
//  Created by Raymond Tsang on 11/10/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseStorage

//This struct is used for each element of the "topDogs" array
struct Doggo{
    var uid: String //owner id + dog postiion
    var score: Int
}

class DoggoViewController: UIViewController {

    @IBOutlet weak var doggoImageView: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    
    let uid = Auth.auth().currentUser?.uid
    let usersRef = Database.database().reference().child("all-users")
    let topRef = Database.database().reference().child("topDoggos")
    
    //Think of this as an ordered dictionary, where each element contains the uuid and the score
    var topDogs : Array<Doggo> = Array()
    
    var currentOwner = "current owner"
    var currentDog = "current dog"
    var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        showNextDog()
        loadTopDoggos()
    }
    
    func loadTopDoggos() {
        let serialq = DispatchQueue(label: "loadtop")
        
        serialq.async {
            
            //this semaphore is used for the first call to the database
            let semaphore = DispatchSemaphore(value: 0)
            
            var value = NSArray()
            
            //first call used to get the "topDoggos" array from firebase
            self.topRef.observeSingleEvent(of: .value, with: { (snapshot) in
                value = snapshot.value as! NSArray
                
                semaphore.signal()
            })
            
            semaphore.wait()
            
            //Loop through "value" array and get the score for each element
            for val in value {
                //this semaphore is used for the second call to the database
                let dogStr = val as! String
                
                let uId = String(dogStr.prefix(dogStr.count - 1))
                let dogNum = Int(String(dogStr.suffix(1)))!
                
                //second call to database to get the score
                self.usersRef.child(uId).child("dogs").observeSingleEvent(of: .value, with: { (snaps) in
                    
                    let dict = snaps.value as! NSArray
                    let dog = dict[Int(dogNum)] as! Dictionary<String, String>
                    
                    let dscore = Int(dog["score"]!)
                    
                    self.topDogs.append(Doggo(uid: dogStr, score: dscore!))
                    
                    semaphore.signal()
                })
                semaphore.wait()
            }
            
        }
    }
    
    @IBAction func ratingPressed(_ sender: UIButton) {
        //print("Rating: /(sender.tag) submitted!")
        
        // update dog's rating in the database
        var updatedScore = 0
        updatedScore = currentScore + sender.tag
        self.usersRef.child(currentOwner).child("dogs").child(currentDog).updateChildValues(["score": String(updatedScore)])
        currentScore = updatedScore
        
        //compare ratings against top 5 and adjust as needed
        compareAndUpdateDoggos()
        
        // proceed to next dog
        showNextDog()
    }
    
    func compareAndUpdateDoggos(){
        
        var counter = 0 //position to insert at in array in second outer loop
        var replaced = false //keeps track of whether the score of the current dog is high enough or not
        var exists = false //check if exists
        var counter2 = 0 //keep track of position in first outer loop
        
        //this for loop checks if current dog exists in the array
        for element in topDogs {
            let uuid = currentOwner + currentDog
            //if it does exist, update the score in the array
            if (element.uid == uuid) {
                exists = true
                topDogs[counter2].score = currentScore
                //special cases
                //if index is 0, simply exit loop
                if(counter2 == 0){
                    break
                }
                //if index is 1, check if 0th element score is greater
                if(counter2 == 1){
                    if(currentScore > topDogs[0].score){
                        topDogs.swapAt(0, 1)
                        replaced = true
                        break
                    }
                }
                //general case
                for n in 0...(counter2-1) {
                    //let uidEle = topDogs[n].uid
                    let scoreEle = topDogs[n].score
                    
                    //if the currentScore is higher than the element's score,
                    //remove the current dog from the array and insert at index "n"
                    if(currentScore > scoreEle){
                        let temp = topDogs.remove(at: counter2)
                        topDogs.insert(temp, at: n)
                        replaced = true
                        break
                    }
                }
                break
            }
            counter2 = counter2 + 1
        }
        
        //if the current dog doesnt already exist, than check and see if currentScore is high enough
        if(exists == false){
            
            //updates topDogs array
            for element in topDogs {
                //print(element)
                let eleScore = element.score
                //this checks whether the current score is higher than the score of the element
                //we want to stop at the first instance this happens and insert there and then delete the last element
                if(currentScore > eleScore){
                    let uuid = currentOwner + currentDog
                    topDogs.insert(Doggo(uid: uuid, score: currentScore), at: counter)
                    topDogs.removeLast()
                    replaced = true
                    break
                }
                counter = counter + 1
            }
        }
        
        //if nothing changes, do not update
        if(replaced == false){
            return
        }
        
        //array to be sent to Firebase
        var topDogArray : Array<String> = Array()
        
        for element in topDogs {
            topDogArray.append(element.uid)
        }
        
        //cast topDogArray as NSArray
        let topDArr = topDogArray as NSArray
        //update database in Firebase: setValue was used because I want to replace the entire array in "topDoggos"
        self.topRef.setValue(topDArr)
        
    }
    
    func setDogPic(toName dogName : String) {
        // create ref to that image
        let storageRef = Storage.storage().reference(withPath: dogName)
        
        // update image
        storageRef.getData(maxSize: 1 * 1024 * 1024) {data,error in
            if error != nil {
                //print("image failed to download")
                self.doggoImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
            else {
                self.doggoImageView.image = UIImage(data: data!)
                //print("image download success!")
                self.doggoImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
    func showNextDog() {
        let serialQueue = DispatchQueue(label: "it-is-serial")
        doggoImageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        serialQueue.async {
            
            let semaphore = DispatchSemaphore(value: 0)
            
            // pick a random user id
            var randUser = "<not set>"
            self.usersRef.observeSingleEvent(of: .value) {(Snapshot) in
                let dict = Snapshot.value as! Dictionary<String, Any>
                let index: Int = Int(arc4random_uniform(UInt32(dict.count)))
                randUser = Array(dict.keys)[index]
                
                self.currentOwner = randUser
                
                semaphore.signal()
            }
            semaphore.wait()
            print("randUser is \(randUser)")
            
            
            // pick random dog from above user
            var screenname = ""
            var filename = ""
            self.usersRef.child(randUser).child("dogs").observeSingleEvent(of: .value) { snapshot in
                if (snapshot.childrenCount == 0) {
                    screenname = "Bob"
                    filename = "bob.jpg"
                    self.currentDog = "0"
                    self.currentOwner = "default"
                    
                    // if random user doesn't contain a dog, display Bob
                    self.usersRef.child("default").child("dogs").observeSingleEvent(of: .value) { snapshot in
                        let dict = snapshot.value as! NSArray
                        let dog = dict[0] as! Dictionary<String, String>
                        self.currentScore = Int(dog["score"]!)!
                        print("Bob's current score: ", self.currentScore)
                    }
                    
                } else {
                    let randDog = Int(arc4random_uniform(UInt32(snapshot.childrenCount)))
                    let dict = snapshot.value as! NSArray
                    let dog = dict[randDog] as! Dictionary<String, String>
                    
                    self.currentDog = String(randDog)
                    
                    screenname = dog["screenname"]!
                    filename = dog["filename"]!
                    self.currentScore = Int(dog["score"]!)!
                    print("current score: ", self.currentScore)
                
                }
                semaphore.signal()
            }
            semaphore.wait()
            print("\(screenname), \(filename)\n")
            
            //change picture
            DispatchQueue.main.async {
                self.dogName.text = screenname
                self.setDogPic(toName: filename)
            }
        }
        
    }

}
