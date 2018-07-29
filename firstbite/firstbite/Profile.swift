//
//  Profile.swift
//  firstbite
//
//  Created by Kelvin Lee on 2018-07-16.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Profile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var firestore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    
    //Creating variables
    var UserName = ""
    var UserChildName = ""
    var UserChildGender = ""
    var UserChildHeight = Double()
    var AgeTrend: [Int] = [-1, -1, -1, -1, -1]
    var AgeTrendCount = 0
    var HeightTrend: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]
    var HeightTrendCount = 0
    var UserChildWeight = Double()
    var WeightTrend: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]
    var WeightTrendCount = 0
    var image = UIImagePickerController()
    var UserChildBirthYear = Int()
    var UserChildBirthMonth = Int()
    var UserChildBirthDay = Int()
    var UserChildAge = Int()
    
    //Display User's Child
    @IBOutlet weak var displayWhoseChild: UILabel!
    func WhoseChild() {
        displayWhoseChild.text = "  " + UserName + "'s baby"
    }
    
    //Display Child's name
    @IBOutlet weak var displayChildName: UILabel!
    func ChildName() {
        displayChildName.text = "Name: " + UserChildName
    }
    
    //Display Child's age
    @IBOutlet weak var displayChildAge: UILabel!
    func ChildAge(_ age: inout Int) {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        if month >= UserChildBirthMonth {
            age = 12 * (year - UserChildBirthYear) + (month - UserChildBirthMonth)
        }
        else {
            age = 12 * (year - UserChildBirthYear) + (UserChildBirthMonth - month)
        }
        
        displayChildAge.text = "Age: " + String(age) + " months"
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
    
    //Display Child's Pictures
    @IBOutlet weak var displayChildPicture: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Save Image in Persistence
            let imageData:NSData = UIImageJPEGRepresentation(image, 1)! as NSData
            UserDefaults.standard.set(imageData, forKey: "savedImage")
            let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
            displayChildPicture.image = UIImage(data: data as Data)
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
    
    //Display Trend
    //Age Labels
    @IBOutlet weak var age1: UILabel!
    @IBOutlet weak var age2: UILabel!
    @IBOutlet weak var age3: UILabel!
    @IBOutlet weak var age4: UILabel!
    @IBOutlet weak var age5: UILabel!
    func displayAge() {
        firestore = Firestore.firestore()
        let doc = firestore.collection(userID).document(userDocumentName)
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                let array0 = d["Age_trend0"] as! Int
                let array1 = d["Age_trend1"] as! Int
                let array2 = d["Age_trend2"] as! Int
                let array3 = d["Age_trend3"] as! Int
                let array4 = d["Age_trend4"] as! Int
                
                if array0 != -1 {
                    self.age1.text = String(array0)
                }
                else {
                    self.age1.text = "-"
                }
                
                if array1 != -1 {
                    self.age2.text = String(array1)
                }
                else {
                    self.age2.text = "-"
                }
                
                if array2 != -1 {
                    self.age3.text = String(array2)
                }
                else {
                    self.age3.text = "-"
                }
                
                if array3 != -1 {
                    self.age4.text = String(array3)
                }
                else {
                    self.age4.text = "-"
                }
                
                if array4 != -1 {
                    self.age5.text = String(array4)
                }
                else {
                    self.age5.text = "-"
                }
            }
        })
    }
    
    //Height Labels
    @IBOutlet weak var height1: UILabel!
    @IBOutlet weak var height2: UILabel!
    @IBOutlet weak var height3: UILabel!
    @IBOutlet weak var height4: UILabel!
    @IBOutlet weak var height5: UILabel!
    func displayHeight() {
        firestore = Firestore.firestore()
        let doc = firestore.collection(userID).document(userDocumentName)
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                let array0 = d["Height_trend0"] as! Double
                let array1 = d["Height_trend1"] as! Double
                let array2 = d["Height_trend2"] as! Double
                let array3 = d["Height_trend3"] as! Double
                let array4 = d["Height_trend4"] as! Double
                
                if array0 != 0.0 {
                    self.height1.text = String(array0)
                }
                else {
                    self.height1.text = "-"
                }
                
                if array1 != 0.0 {
                    self.height2.text = String(array1)
                }
                else {
                    self.height2.text = "-"
                }
                
                if array2 != 0.0 {
                    self.height3.text = String(array2)
                }
                else {
                    self.height3.text = "-"
                }
                
                if array3 != 0.0 {
                    self.height4.text = String(array3)
                }
                else {
                    self.height4.text = "-"
                }
                
                if array4 != 0.0 {
                    self.height5.text = String(array4)
                }
                else {
                    self.height5.text = "-"
                }
            }
        })
    }
    
    //Weight Labels
    @IBOutlet weak var weight1: UILabel!
    @IBOutlet weak var weight2: UILabel!
    @IBOutlet weak var weight3: UILabel!
    @IBOutlet weak var weight4: UILabel!
    @IBOutlet weak var weight5: UILabel!
    func displayWeight() {
        firestore = Firestore.firestore()
        let doc = firestore.collection(userID).document(userDocumentName)
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                let array0 = d["Weight_trend0"] as! Double
                let array1 = d["Weight_trend1"] as! Double
                let array2 = d["Weight_trend2"] as! Double
                let array3 = d["Weight_trend3"] as! Double
                let array4 = d["Weight_trend4"] as! Double
                
                if array0 != 0.0 {
                    self.weight1.text = String(array0)
                }
                else {
                    self.weight1.text = "-"
                }
                
                if array1 != 0.0 {
                    self.weight2.text = String(array1)
                }
                else {
                    self.weight2.text = "-"
                }
                
                if array2 != 0.0 {
                    self.weight3.text = String(array2)
                }
                else {
                    self.weight3.text = "-"
                }
                
                if array3 != 0.0 {
                    self.weight4.text = String(array3)
                }
                else {
                    self.weight4.text = "-"
                }
                
                if array4 != 0.0 {
                    self.weight5.text = String(array4)
                }
                else {
                    self.weight5.text = "-"
                }
            }
        })
    }
    
    //Update Stat
    @IBAction func updateStat(_ sender: Any) {
        let doc = firestore.collection(userID).document(userDocumentName)
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                let Count1 = d["AgeTrendCount"] as! Int
                let Count2 = d["HeightTrendCount"] as! Int
                let Count3 = d["WeightTrendCount"] as! Int
                
                let BirthYear = d["Child_birthyear"] as! Int
                let BirthMonth = d["Child_birthmonth"] as! Int
                let date = Date()
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                var age: Int
                if month >= BirthMonth {
                    age = 12 * (year - BirthYear) + (month - BirthMonth)
                }
                else {
                    age = 12 * (year - BirthYear) + (BirthMonth - month)
                }
                if Count1 < 5 {
                    let entry = "Age_trend" + String(Count1)
                    doc.updateData([entry: age])
                    doc.updateData(["AgeTrendCount": Count1 + 1])
                }
                else {
                    let a1 = d["Age_trend1"] as! Int
                    let a2 = d["Age_trend2"] as! Int
                    let a3 = d["Age_trend3"] as! Int
                    let a4 = d["Age_trend4"] as! Int
                    
                    doc.updateData(["Age_trend0": a1])
                    doc.updateData(["Age_trend1": a2])
                    doc.updateData(["Age_trend2": a3])
                    doc.updateData(["Age_trend3": a4])
                    doc.updateData(["Age_trend4": age])
                }
                
                self.UserChildHeight = (Double(self.inputNewHeight.text!))!
                doc.updateData(["Child_height": self.UserChildHeight])
                self.ChildHeight()
                if Count2 < 5 {
                    let entry = "Height_trend" + String(Count2)
                    doc.updateData([entry: self.UserChildHeight])
                    doc.updateData(["HeightTrendCount": Count2 + 1])
                }
                else {
                    let h1 = d["Height_trend1"] as! Double
                    let h2 = d["Height_trend2"] as! Double
                    let h3 = d["Height_trend3"] as! Double
                    let h4 = d["Height_trend4"] as! Double
                    
                    doc.updateData(["Height_trend0": h1])
                    doc.updateData(["Height_trend1": h2])
                    doc.updateData(["Height_trend2": h3])
                    doc.updateData(["Height_trend3": h4])
                    doc.updateData(["Height_trend4": self.UserChildHeight])
                }
                
                self.UserChildWeight = (Double(self.inputNewWeight.text!))!
                doc.updateData(["Child_weight": self.UserChildWeight])
                self.ChildWeight()
                if Count3 < 5 {
                    let entry = "Weight_trend" + String(Count3)
                    doc.updateData([entry: self.UserChildWeight])
                    doc.updateData(["WeightTrendCount": Count3 + 1])
                }
                else {
                    let w1 = d["Weight_trend1"] as! Double
                    let w2 = d["Weight_trend2"] as! Double
                    let w3 = d["Weight_trend3"] as! Double
                    let w4 = d["Weight_trend4"] as! Double
                    
                    doc.updateData(["Weight_trend0": w1])
                    doc.updateData(["Weight_trend1": w2])
                    doc.updateData(["Weight_trend2": w3])
                    doc.updateData(["Weight_trend3": w4])
                    doc.updateData(["Weight_trend4": self.UserChildWeight])
                }
            }
        })
        
        displayAge()
        displayHeight()
        displayWeight()
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
        let doc = firestore.collection(userID).document(userDocumentName)
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
            self.ChildAge(&self.UserChildAge)
            self.ChildGender()
            self.ChildHeight()
            self.ChildWeight()
        })
        print(UserChildAge)
        displayAge()
        displayHeight()
        displayWeight()
    }
    
    @IBAction func doBtnSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch {}
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
