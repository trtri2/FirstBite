//
//  BottlefeedingViewController.swift
//  homework3
//
//  Created by Han Yang, Winston Ye, Jeff Wang, Leon Trieu on 2018-07-02.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

// Functionality: used to log bottlefeeding into the Food Diary logs
class BottlefeedingViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var dataTextField: UITextField!
    
    @IBOutlet weak var formulaTextFieldOutlet: UITextField!
    
    @IBOutlet weak var amountTextFieldOutlet: UITextField!
    
    @IBOutlet weak var noteOutlet: UITextView!
    
    @IBOutlet var babyFormButton: UIButton!
    
    @IBOutlet var amountSlider: UISlider!
    
    //reaction stuff
    @IBOutlet var reactionSlider: UISlider!
    @IBOutlet var reactionLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    //create database object
    var fstore: Firestore!
    // get user ID reference
    var userID = Auth.auth().currentUser!.uid
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //set navigation buttons
        self.dataTextField.delegate = self
        self.formulaTextFieldOutlet.delegate = self
        self.amountTextFieldOutlet.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
    
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dataTextField.text = dateFormatter.string(from: Date())
        
        //initiate database object
        fstore = Firestore.firestore()
    }
    
    // Functionality: used to allow the user to pick a date upon pressing the text field 
    @IBAction func changeTextFieldToDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(BottlefeedingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    //display date and time in textfield when datePicker value is changed
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dataTextField.text = dateFormatter.string(from: sender.date)
//        dateFormatter.dateStyle = DateFormatter.Style.short
//        dateFormatter.timeStyle = DateFormatter.Style.short
//        dataTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //hide software keyboard when user touches screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sliderDIdChange(_ sender: UISlider) {
        amountTextFieldOutlet.text = "\(Int(sender.value))"
    }
    
    // Functionality: gives an estimated amount of baby formula based off of baby weight in pounds
    @IBAction func babyFormulaCalculator(_ sender: Any) {
        babyFormulaAlert()
    }
    
    // Functionality: display alert
    func babyFormulaAlert(){
        let alert: UIAlertController = UIAlertController(title: "Baby Formula Calculator", message: "Input your baby's weight in pounds.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Weight in pounds" // default text field
            textField.keyboardType = .numberPad
            textField.delegate = self as? UITextFieldDelegate
        }
        
        alert.addAction(UIAlertAction(title: "Calculate", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if (textField?.text != ""){
            let valueGiven = Int((textField?.text)!)
            var valueCalculated = valueGiven! * 11
            
            if(valueCalculated >= 500){
                valueCalculated = 500
            }
            self.amountTextFieldOutlet.text = "\(valueCalculated)"
            self.amountSlider.value = Float(valueCalculated)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // Functionality: checks to see if value changed is greater than 500 mL
    @IBAction func textAmountChanged(_ sender: Any) {
        if let convertedValue = Int(amountTextFieldOutlet.text!){
            if(convertedValue >= 500){
                amountSlider.value = 500
                amountTextFieldOutlet.text = "500"
            }
            else{
                amountSlider.value = Float(convertedValue)
            }
        }
    }
    
    //reaction changer
    @IBAction func reactionChanged(_ sender: Any) {
        if(reactionSlider.value >= 0.75){
            reactionLabel.text = "🤤"
        }
        else if(reactionSlider.value <= 0.25){
            reactionLabel.text = "😧"
        }
        else{
            reactionLabel.text = "😐"
        }
    }
    
    // Functionality: for database storage, emoji's possibly dangerous
    func getReaction() -> String{
        var reaction: String
        if(reactionLabel.text == "🤤"){
            reaction = "Good"
            return reaction
        }
        else if(reactionLabel.text == "😧"){
            reaction = "Bad"
            return reaction
        }
        else if(reactionLabel.text == "😐"){
            reaction = "Neutral"
            return reaction
        }
        return "Neutral"
    }
    
    @IBAction func pressedEditNotes(_ sender: Any) {

        let alert: UIAlertController = UIAlertController(title: "Notes", message: "Add notes.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Notes" // default text field
            self.noteOutlet.text = ""
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
    
    
    // Functionality: saves the data to the database upon press
    @objc func saveData() {
        let reaction = getReaction()
        var tempNotes = noteOutlet.text!

        if(tempNotes == "Add optional notes such as allergies, reactions, etc..."){
            tempNotes = " "
        }
        
        if(formulaTextFieldOutlet.text! == "")||(formulaTextFieldOutlet.text! == " "){
            formulaTextFieldOutlet.text = "Baby Formula"
        }

        fstore.collection(userID).addDocument(data: ["datetime":dataTextField.text!,"Activity":"Bottlefeeding","Formula Name":formulaTextFieldOutlet.text!,"Formula Amount":amountTextFieldOutlet.text!,"Notes":tempNotes, "Reaction":reaction, "userID":userID, "isLog":"true"])
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

