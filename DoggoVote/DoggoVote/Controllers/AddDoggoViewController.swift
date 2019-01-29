//
//  AddDoggoViewController.swift
//  DoggoVote
//
//  Created by Raymond Tsang on 11/15/18.
//  Copyright © 2018 Raymond Tsang. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class AddDoggoViewController: UIViewController {
    
    let databaseRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    let currentUser = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var doggoImageButton: UIButton!
    @IBOutlet weak var doggoNameTextField: UITextField!
    
    var doggoImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // create a popup that allows user to select image from either camera or photo library
    @IBAction func doggoImagePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            //print("Get photo from camera")
            self.camera()
        }
        alert.addAction(camera)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            //print("Get photo from photo library")
            self.photoLibrary()
        }
        alert.addAction(photoLibrary)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getNumDogs() -> Int {
        var dogCount = 0
        let currentUserDogs = databaseRef.child("all-users").child(currentUser).child("dogs")
        let semaphore = DispatchSemaphore(value: 0)
        currentUserDogs.observe(.value) { (snapshot) in
            dogCount = Int(snapshot.childrenCount)
            semaphore.signal()
        }
        semaphore.wait()
        return dogCount
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        // trim full file path to just file name
        let index = doggoImageURL!.absoluteString.lastIndex(of: "/")
        let filename = String(doggoImageURL!.absoluteString.suffix(from: index!))
        //print(filename)
        
        // add doggo to firebase database
        let doggoInfo = ["filename": filename, "score": "\(0)", "screenname": doggoNameTextField.text!]
        
        let currentUserDogs = databaseRef.child("all-users").child(currentUser).child("dogs")
        let queue = DispatchQueue(label: "myQueue")
        var dogCount = 0

        queue.async {
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global(qos: .userInitiated).async {
                dogCount = self.getNumDogs()
                semaphore.signal()
            }
            semaphore.wait()
            //print("correct dog count? is \(dogCount)")
            currentUserDogs.child("\(dogCount)").setValue(doggoInfo) { (error, reference) in
                // do stuff for completion block
            }
            
            // add doggo pic to firebase storage
            DispatchQueue.main.async {
                self.storageRef.child(filename).putFile(from: self.doggoImageURL!, metadata: nil) { (metadata, error) in
                    // do stuff in completion block
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }

        
        
    }
}

// MARK: UIImagePickerControllerDelegate extension
extension AddDoggoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // https://hackernoon.com/swift-access-ios-camera-and-photo-library-dc1dbe0cdd76
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //print(info[UIImagePickerController.InfoKey.imageURL]!)
        doggoImageURL = (info[UIImagePickerController.InfoKey.imageURL] as! URL)
        DispatchQueue.main.async {
            let doggoImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.doggoImageButton.setImage(doggoImage, for: .normal)
            self.doggoImageButton.setNeedsDisplay()
        }
        //print("set image")
        dismiss(animated: true, completion: nil)
    }
    
}
