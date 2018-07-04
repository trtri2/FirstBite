//
//  BreastfeedingViewController.swift
//  homework3
//
//  Created by Healthy 7 Group on 2018-06-30.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit

// Functionality: used to allow the user to input breastfeeding to the history log
class BreastfeedingViewController: UIViewController {
    
    var dateTimeTemp = ""
    var feedTimeTemp = ""
    var counterL = 0
    var counterR = 0
    var timer = Timer()
    //var data:[String] = []
    
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var leftTimer: UILabel!
    @IBOutlet weak var rightTimer: UILabel!
    @IBOutlet weak var leftBtnOutlet: UIButton!
    @IBOutlet weak var rightBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //adding datepicker at bottom
        changeTextFieldToDate(dataTextField)
    }
    
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
    
//    @IBAction func didChangeTime(_ sender: UIDatePicker) {
//        let date:Date = sender.date
//        let formatter:DateFormatter = DateFormatter()
//        formatter.dateFormat = "EEEE MMM dd, h:mm a"
//        dateTimeTemp = formatter.string(from: date)
//    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc func updateTimerL() {
        counterL += 1
        leftTimer.text = timeString(time: TimeInterval(counterL))
    }
    
    @objc func updateTimerR () {
        counterR += 1
        rightTimer.text = timeString(time: TimeInterval(counterR))
    }
    
    // Functionality: used to allow the user to start the timer on the left breast
    @IBAction func LButton(_ sender: UIButton) {
        if (sender.titleLabel?.text == "L GO"){
            timer.invalidate()
            sender.setTitle("L PAUSE", for: .normal)
            rightBtnOutlet.setTitle("R GO", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerL), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            sender.setTitle("L GO", for: .normal)
        }
        
    }
    
     // Functionality: used to allow the user to start the timer on the right breast
    @IBAction func RButton(_ sender: UIButton) {
        if (sender.titleLabel?.text == "R GO"){
            timer.invalidate()
            sender.setTitle("R PAUSE", for: .normal)
            leftBtnOutlet.setTitle("L GO", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerR), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            sender.setTitle("R GO", for: .normal)
        }
    }
    
     // Functionality: save breastfeeding button
    @IBAction func SButton(_ sender: UIButton) {
        timer.invalidate()
        leftBtnOutlet.setTitle("L GO", for: .normal)
        rightBtnOutlet.setTitle("R GO", for: .normal)
    }
    
    // Functionality: saves data
    @objc func saveData() {
//        let date:Date = datePicker.date
//        let formatter:DateFormatter = DateFormatter()
//            formatter.dateFormat = "MMM dd, h:mm a"
//            dateTimeTemp = formatter.string(from: date)
        let tempResult = "Breastfeed: " + dataTextField.text! + " L " + (leftTimer.text)! + " R " + (rightTimer.text)!
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
