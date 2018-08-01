//
//  BMITableViewController.swift
//  firstbite
//
//  Created by thtrieu on 7/30/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

    var fstore: Firestore!

class BMITableViewController: UIViewController, UITextFieldDelegate{
    
    var fstore = Firestore.firestore()
    var userID = Auth.auth().currentUser!.uid
    
    //text field var for height and weight
    @IBOutlet weak var textHeight: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    
    //text field var for result
    @IBOutlet weak var textResult: UITextField!
    
    var height = Double()
    var weight = Double()
    var result = Double()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.textHeight.delegate = self
        self.textWeight.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }

     //when pressed, collects the user's height and weight from profile in database
    @IBAction func collectProfile(_ sender: Any) {
        var tempArr = Array<Int>()
        fstore.collection(userID).document("Profile").getDocument(completion:{(snapshot,error) in
            if let doc = snapshot?.data(){
                
                tempArr = doc["Child_heights"] as! Array<Int>
                self.textHeight.text = String(tempArr[tempArr.count-1])
                self.height = Double(tempArr[tempArr.count-1])
                tempArr = doc["Child_weights"] as! Array<Int>
                self.textWeight.text = String(tempArr[tempArr.count-1])
                self.weight = Double(tempArr[tempArr.count-1])
                
            }
            // convert the height of cm's to metres
          //  self.calculate(finalHeight: (self.height/100), finalWeight: self.weight)
        })
        
    }

    
    //calculates BMI using kg/m^2
    func calculate(finalHeight: Double, finalWeight: Double){

        let newHeight = finalHeight * finalHeight
        if (newHeight > 0){
            result = finalWeight / newHeight
        } else {
            result = 0
        }
     
        textResult.text = String(result)
    }
    func viewDidAppear(_animated:Bool){
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    
    //when user press calculate, calls the calculate function

    @IBAction func pressCalculate(_ sender: Any) {
        var heightHolder = String()
        heightHolder = textHeight.text!
        var weightHolder = String()
        weightHolder = textWeight.text!
        if (heightHolder != "" || weightHolder != ""){
        height = Double(heightHolder)!
        weight = Double(weightHolder)!
        calculate(finalHeight: (height/100), finalWeight: weight)
        }
    }
    
    
    @IBAction func infantBoy(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.dietitians.ca/Downloads/Public/LFA-WFA_Birth-24_BOYS_EN.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func infantGirl(_ sender: Any) {
     UIApplication.shared.open(URL(string: "https://www.dietitians.ca/Downloads/Public/LFA-WFA_Birth-24_GIRLS_EN.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func bmiTable(_ sender: Any) {
         UIApplication.shared.open(URL(string: "https://www.dietitians.ca/Downloads/Public/0911-0189-BMI_Metric.aspx")! as URL, options: [:], completionHandler: nil)
    }
    
 
    
    
    
    

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}

}
