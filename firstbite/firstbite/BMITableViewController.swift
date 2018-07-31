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

class BMITableViewController: UIViewController{
    
    var fstore = Firestore.firestore()
    var userID = Auth.auth().currentUser!.uid
    
    //text field var for height and weight
    @IBOutlet weak var textHeight: UITextField!
    @IBOutlet weak var textWeight: UITextField!
    
    //text field var for result
    @IBOutlet weak var textResult: UITextField!
    
    var height = Int()
    var weight = Int()

    
    //when pressed, collects the user's height and weight from profile in database
    @IBAction func collectProfile(_ sender: Any) {
     var tempArr = Array<Int>()
        fstore.collection(userID).document("Profile").getDocument(completion:{(snapshot,error) in
            if let doc = snapshot?.data(){
           
            tempArr = doc["Child_heights"] as! Array<Int>
            self.textHeight.text = String(tempArr[tempArr.count-1])
                
            tempArr = doc["Child_weights"] as! Array<Int>
            self.textWeight.text = String(tempArr[tempArr.count-1])
            
            
            }
      //      calculate()
        })
        
    }
    
    //calculates BMI using kg/m^2
    func calculate(finalHeight: Int, finalWeight: Int){
        var result = Int()
        
        textResult.text = String(result)
    }
    
    @IBAction func pressCalc(_ sender: Any) {
    }
    
    

override func viewDidLoad(){
    super.viewDidLoad()
    
   
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}

}
