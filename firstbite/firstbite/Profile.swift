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
    //Creating test variables
    let UserName = "Kelvin"
    let UserChildName = "Mina"
    var h = 1.6
    var w = 50.0
    var image = UIImagePickerController()
    
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
        displayChildAge.text = "219 months"
    }
    
    //Display Child's gender
    @IBOutlet weak var displayChildGender: UILabel!
    func ChildGender() {
        displayChildGender.text = "Girl"
    }
    
    //Display Child's Height
    @IBOutlet weak var displayChildHeight: UILabel!
    func ChildHeight() {
        if h == 0.0 {
            displayChildHeight.text = "N/A"
        }
        else {
            displayChildHeight.text = String(h)
        }
    }
    
    //Edit Child's Height
    @IBOutlet weak var inputNewHeight: UITextField!
    @IBAction func submitNewHeight(_ sender: Any) {
        h = Double(inputNewHeight.text!)!
        ChildHeight()
    }
    
    //Display Child's Weight
    @IBOutlet weak var displayChildWeight: UILabel!
    func ChildWeight() {
        if w == 0.0 {
            displayChildWeight.text = "N/A"
        }
        else {
            displayChildWeight.text = String(w)
        }
    }
    
    //Edit Child's Weight
    @IBOutlet weak var inputNewWeight: UITextField!
    @IBAction func submitNewWeight(_ sender: Any) {
        w = Double(inputNewWeight.text!)!
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
        WhoseChild()
        ChildName()
        ChildAge()
        ChildGender()
        ChildHeight()
        ChildWeight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
