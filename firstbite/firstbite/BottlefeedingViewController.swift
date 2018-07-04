//
//  BottlefeedingViewController.swift
//  homework3
//
//  Created by Healthy 7 Group on 2018-07-02.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit

// Functionality: used to log breastfeeding into the Food Diary logs
class BottlefeedingViewController: UIViewController {
    
    @IBOutlet weak var dataTextField: UITextField!
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    @IBOutlet weak var formulaTextFieldOutlet: UITextField!
    
    @IBOutlet weak var amountTextFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //adding datepicker at bottom
        changeTextFieldToDate(dataTextField)
    }
    
    // Functionality: used to allow the user to pick a date upon pressing the text field 
    func changeTextFieldToDate(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(BottlefeedingViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dataTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sliderDIdChange(_ sender: UISlider) {
        amountTextFieldOutlet.text = "\(Int(sender.value))"
    }
    
    // Functionality: saves the data to the history log upon press
    @objc func saveData() {
//        let date:Date = datePickerOutlet.date
//        let formatter:DateFormatter = DateFormatter()
//        formatter.dateFormat = "MMM dd, h:mm a"
//        let dateTimeTemp = formatter.string(from: date)
        let tempResult = "Bottlefeed: " + dataTextField.text! + " " + formulaTextFieldOutlet.text! + " " + amountTextFieldOutlet.text! + " ml"
        if var data:[String] = UserDefaults.standard.value(forKey: "breastfeed") as? [String] {
            data.insert(tempResult, at: 0)
            UserDefaults.standard.set(data, forKey: "breastfeed")
        } else {
            var data:[String] = []
            data.insert(tempResult, at: 0)
            UserDefaults.standard.set(data, forKey: "breastfeed")
        }
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

