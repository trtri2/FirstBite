//
//  BottlefeedingViewController.swift
//  homework3
//
//  Created by Han Yang, Winston Ye, Jeff Wang, Leon Trieu on 2018-07-02.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit
import FirebaseFirestore

// Functionality: used to log bottlefeeding into the Food Diary logs
class BottlefeedingViewController: UIViewController {
    
    @IBOutlet weak var dataTextField: UITextField!
    
    @IBOutlet weak var formulaTextFieldOutlet: UITextField!
    
    @IBOutlet weak var amountTextFieldOutlet: UITextField!
    
    @IBOutlet weak var noteOutlet: UITextView!
    
    @IBOutlet var babyFormButton: UIButton!
    
    @IBOutlet var amountSlider: UISlider!
    
    let dateFormatter = DateFormatter()
    
    var fstore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
    
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dataTextField.text = dateFormatter.string(from: Date())
        
        fstore = Firestore.firestore()
    }
    
    // Functionality: used to allow the user to pick a date upon pressing the text field 
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
    
    @IBAction func sliderDIdChange(_ sender: UISlider) {
        amountTextFieldOutlet.text = "\(Int(sender.value))"
    }
    
    // Functionality: gives an estimated amount of baby formula based off of baby weight in pounds
    @IBAction func babyFormulaCalculator(_ sender: Any) {
        babyFormulaAlert()
    }
    
    func babyFormulaAlert(){
        let alert: UIAlertController = UIAlertController(title: "Baby Formula Calculator", message: "Input your baby's weight in pounds.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Weight in pounds" // default text field
            textField.keyboardType = .numberPad
            textField.delegate = self as? UITextFieldDelegate
        }
        
        alert.addAction(UIAlertAction(title: "Calculate", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let valueGiven = Int((textField?.text)!)
            
            var valueCalculated = valueGiven! * 11
            
            if(valueCalculated >= 500){
                valueCalculated = 500
            }
            self.amountTextFieldOutlet.text = "\(valueCalculated)"
            self.amountSlider.value = Float(valueCalculated)
            
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
    
    
    
    // Functionality: saves the data to the history log upon press
    @objc func saveData() {
        fstore.collection("Log").addDocument(data: ["datetime":dataTextField.text!,"Activity":"Bottlefeeding","Formula Name":formulaTextFieldOutlet.text!,"Formula Amount":amountTextFieldOutlet.text!,"Notes":noteOutlet.text!])
//        let date:Date = datePickerOutlet.date
//        let formatter:DateFormatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, h:mm a"
//        let dateTimeTemp = formatter.string(from: date)
//        let tempResult = dataTextField.text! + " Bottlefeed: " + formulaTextFieldOutlet.text! + " " + amountTextFieldOutlet.text! + " ml"
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

