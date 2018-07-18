//
//  BreastfeedingViewController.swift
//
//  Created by Han Yang, Winston Ye, Jeff Wang, Kelvin Lee on 2018-06-30.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//
// bug fix on 2018-07-04, date now shows up after second press

import UIKit
import FirebaseFirestore

// Functionality: used to allow the user to input breastfeeding to the history log
class BreastfeedingViewController: UIViewController {
    
    var dateTimeTemp = ""
    var feedTimeTemp = ""
    var counterL = 0
    var counterR = 0
    var timer = Timer()
    //var data:[String] = []
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var dataTextField: UITextField! //date
    @IBOutlet weak var leftTimer: UILabel!
    @IBOutlet weak var rightTimer: UILabel!
    @IBOutlet weak var leftBtnOutlet: UIButton!
    @IBOutlet weak var rightBtnOutlet: UIButton!
    @IBOutlet weak var noteOutlet: UITextView!
    
    //create database object
    var fstore: Firestore!
    //var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dataTextField.text = dateFormatter.string(from: Date())
        
        //Initiate FireStore Object
        fstore = Firestore.firestore()
        //ref = Database.database().reference()
    }
    
    @IBAction func changeTextFieldToDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(BottlefeedingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dataTextField.text = dateFormatter.string(from: sender.date)
        //        dateFormatter.dateStyle = DateFormatter.Style.short
        //        dateFormatter.timeStyle = DateFormatter.Style.short
        //        dataTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //convert seconds into mm:ss format
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    //display left timer in mm:ss format
    @objc func updateTimerL() {
        counterL += 1
        leftTimer.text = timeString(time: TimeInterval(counterL))
    }
    
    //display right timer in mm:ss format
    @objc func updateTimerR () {
        counterR += 1
        rightTimer.text = timeString(time: TimeInterval(counterR))
    }
    
    // Functionality: used to allow the user to start the timer on the left breast
    @IBAction func LButton(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Left Breast"){
            timer.invalidate()
            sender.setTitle("Left Breast Pause", for: .normal)
            rightBtnOutlet.setTitle("Right Breast", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerL), userInfo: nil, repeats: true)
            leftBtnOutlet.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            rightBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        } else {
            timer.invalidate()
            sender.setTitle("Left Breast", for: .normal)
             leftBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        }
        
    }
    
     // Functionality: used to allow the user to start the timer on the right breast
    @IBAction func RButton(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Right Breast"){
            timer.invalidate()
            sender.setTitle("Right Breast Pause", for: .normal)
            leftBtnOutlet.setTitle("Left Breast", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerR), userInfo: nil, repeats: true)
            leftBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
            rightBtnOutlet.backgroundColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
            
        } else {
            timer.invalidate()
            sender.setTitle("Right Breast", for: .normal)
            rightBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        }
    }
    
     // Functionality: save breastfeeding button
    @IBAction func SButton(_ sender: UIButton) {
        timer.invalidate()
        leftBtnOutlet.setTitle("Left Breast", for: .normal)
        rightBtnOutlet.setTitle("Right Breast", for: .normal)
        
         leftBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
         rightBtnOutlet.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    }
    
    @IBAction func pressedEditNotes(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Notes", message: "Edit and change notes.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Notes" // default text field
            textField.text = self.noteOutlet.text
            textField.delegate = self as? UITextFieldDelegate
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            // if character count > 140, throw another alert
            if((textField?.text?.count)! > 140){
                let innerAlert: UIAlertController = UIAlertController(title: "Error", message: "Your note exceeds the character count. Please shorten your note to save it.", preferredStyle: .alert)
                innerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(innerAlert, animated: true, completion: nil)
            }
            else{
                self.noteOutlet.text = textField?.text
                self.noteOutlet.setNeedsDisplay()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    // Functionality: saves data
    @objc func saveData() {
        var tempNotes = noteOutlet.text!
        
        if(tempNotes == "Add optional notes such as allergies, reactions, etc..."){
            tempNotes = " "
        }
        
        fstore.collection("Log").addDocument(data: ["datetime":dataTextField.text!,"Activity":"Breastfeeding","Left Timer":leftTimer.text!,"Right Timer":rightTimer.text!,"Notes":tempNotes])
        
        //ref.child("Log").childByAutoId().setValue(["datetime":dataTextField.text!,"Activity":"Breastfeed","Left Timer":leftTimer.text!,"Right Timer":rightTimer.text!])
        
//        let tempResult = dataTextField.text! + " Breastfeed: " + "L " + (leftTimer.text)! + " R " + (rightTimer.text)!
//        if var data:[String] = UserDefaults.standard.value(forKey: "breastfeed") as? [String] {
//            data.insert(tempResult, at: 0)
//            UserDefaults.standard.set(data, forKey: "breastfeed")
//        } else {
//            var data:[String] = []
//            data.insert(tempResult, at: 0)
//            UserDefaults.standard.set(data, forKey: "breastfeed")
//        }
        showAlert()
    }
    
    func showAlert() {
        let alert:UIAlertController = UIAlertController(title: "Saved Successfully", message: "You can continue adding data here. \nPlease go to Log tab to view saved data", preferredStyle: .alert)
        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            (_:UIAlertAction) in
            print("cancel handler")
        }
        alert.addAction(action1)
        self.present(alert,animated:true) {
            print("alert handler")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
