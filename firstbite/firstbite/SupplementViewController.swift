//
//  SupplementViewController.swift
//  homework3
//
//  Created by Healthy 7 Group on 2018-07-02.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

// Functionality: used to add solid/liquid foods to the history log
class SupplementViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    // pickers
    @IBOutlet weak var quantityPickerOutlet: UIPickerView!
    @IBOutlet weak var categoryPickerOutlet: UIPickerView!
    
    // text fields
    
    @IBOutlet weak var dataTextField: UITextField! // date
    @IBOutlet weak var foodTextFieldOutlet: UITextField!
    @IBOutlet weak var quantityTextFieldOutlet: UITextField!
    @IBOutlet weak var noteOutlet: UITextView!
    
    // picker categories
    let categoryArray:[String] = ["Vegetable/Fruit", "Grain", "Milk/Alternatives", "Meat/Alternatives"]
    let unitsArray:[String] = ["g", "mL", "oz"]
    
    // default strings
    var foodNameString: String = ""
    var categoryTypeString: String = "Vegetable/Fruit"
    var quantityString: String = ""
    var quantityUnitString: String = "g"
    
    let dateFormatter = DateFormatter()
    
    // reaction
    @IBOutlet var reactionSlider: UISlider!
    @IBOutlet var reactionLabel: UILabel!
    
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
        self.dataTextField.delegate = self
        self.foodTextFieldOutlet.delegate = self
        self.quantityTextFieldOutlet.delegate = self
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dataTextField.text = dateFormatter.string(from: Date())
        
        quantityPickerOutlet.delegate = self
        categoryPickerOutlet.delegate = self
        
        quantityPickerOutlet.dataSource = self
        categoryPickerOutlet.dataSource = self
        
        //initiate database object
        fstore = Firestore.firestore()
    }
    
    // Functionality: allows user to pick a date for the date picker upon pressing the text field
    @IBAction func changeTextFieldToDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(BottlefeedingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        dataTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return categoryArray.count
        }
        else{
            return unitsArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1){
            return categoryArray[row]
        }
        else{
            return unitsArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1){
            categoryTypeString = categoryArray[row]
        }
        else{
            quantityUnitString = unitsArray[row]
        }
    }
    
    // Functionality: picks reaction based off slider position
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
    
    @objc func saveData() {
        let reaction = getReaction()
        var tempNotes = noteOutlet.text!
        
        if(tempNotes == "Add optional notes such as allergies, reactions, etc..."){
            tempNotes = " "
        }
        
        fstore.collection(userID).addDocument(data: ["datetime":dataTextField.text!,"Activity":"Supplement","Food Name":foodTextFieldOutlet.text!,"Food Category":categoryTypeString,"Quantity":quantityTextFieldOutlet.text!,"Quantity Unit":quantityUnitString,"Notes":tempNotes,"Reaction":reaction, "userID":userID,"isLog":"true","hasReaction":"true"])

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
