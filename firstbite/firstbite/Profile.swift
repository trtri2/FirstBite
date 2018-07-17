//
//  Profile.swift
//  firstbite
//
//  Created by Kelvin Lee on 2018-07-16.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore

class Profile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var firestore: Firestore!
    
    //Creating test variables
    var UserName = ""
    var UserChildName = ""
    var UserChildGender = ""
    var UserChildHeight = Double()
    var UserChildWeight = Double()
    var image = UIImagePickerController()
    var UserChildBirthYear = Int()
    var UserChildBirthMonth = Int()
    var UserChildBirthDay = Int()
    
    //Display User's Child
    @IBOutlet weak var displayWhoseChild: UILabel!
    func WhoseChild() {
        displayWhoseChild.text = UserName + "'s baby"
    }
    
    //Display Child's name
    @IBOutlet weak var displayChildName: UILabel!
    func ChildName() {
        displayChildName.text = UserChildName
    }
    
    //Display Child's age
    @IBOutlet weak var displayChildAge: UILabel!
    func ChildAge() {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        var age = Int()
        if month >= UserChildBirthMonth {
            age = 12 * (year - UserChildBirthYear) + (month - UserChildBirthMonth)
        }
        else {
            age = 12 * (year - UserChildBirthYear) + (UserChildBirthMonth - month)
        }
        
        displayChildAge.text = String(age) + " months"
    }
    
    //Display Child's gender
    @IBOutlet weak var displayChildGender: UILabel!
    func ChildGender() {
        displayChildGender.text = UserChildGender
    }
    
    //Display Child's Height
    @IBOutlet weak var displayChildHeight: UILabel!
    func ChildHeight() {
        if UserChildHeight == 0.0 {
            displayChildHeight.text = "N/A"
        }
        else {
            displayChildHeight.text = String(UserChildHeight)
        }
    }
    
    //Edit Child's Height
    @IBOutlet weak var inputNewHeight: UITextField!
    @IBAction func submitNewHeight(_ sender: Any) {
        UserChildHeight = Double(inputNewHeight.text!)!
        let doc = firestore.collection("Profile").document("test-user")
        doc.updateData(["Child_height": UserChildHeight])
        ChildHeight()
    }
    
    //Display Child's Weight
    @IBOutlet weak var displayChildWeight: UILabel!
    func ChildWeight() {
        if UserChildWeight == 0.0 {
            displayChildWeight.text = "N/A"
        }
        else {
            displayChildWeight.text = String(UserChildWeight)
        }
    }
    
    //Edit Child's Weight
    @IBOutlet weak var inputNewWeight: UITextField!
    @IBAction func submitNewWeight(_ sender: Any) {
        UserChildWeight = Double(inputNewWeight.text!)!
        let doc = firestore.collection("Profile").document("test-user")
        doc.updateData(["Child_weight": UserChildWeight])
        ChildWeight()
    }
    
    //Display Child's Pictures
    @IBOutlet weak var displayChildPicture: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            displayChildPicture.image = image
        }
        else {
            // Error
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //Import from Library
    @IBAction func importFromLibrary(_ sender: Any) {
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it is complete
        }
    }
    
    //Import from Camera
    @IBAction func importFromCamera(_ sender: Any) {
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.camera
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it is complete
        }
    }
    
    //Separation Line
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Load and Display Data from Firestore
        firestore = Firestore.firestore()
        let doc = firestore.collection("Profile").document("test-user")
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                self.UserName = d["User_name"] as! String
                self.UserChildName = d["Child_name"] as! String
                self.UserChildGender = d["Child_gender"] as! String
                self.UserChildHeight = d["Child_height"] as! Double
                self.UserChildWeight = d["Child_weight"] as! Double
                self.UserChildBirthYear = d["Child_birthyear"] as! Int
                self.UserChildBirthMonth = d["Child_birthmonth"] as! Int
                self.UserChildBirthDay = d["Child_birthday"] as! Int
            }
            self.WhoseChild()
            self.ChildName()
            self.ChildAge()
            self.ChildGender()
            self.ChildHeight()
            self.ChildWeight()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
