//
//  PumpingViewController.swift
//  homework3
//
//  Created by Han Yang, Winston Ye, Jeff Wang, Leon Trieu, Kelvin Lee  on 2018-07-02.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//

import UIKit

class PumpingViewController: UIViewController {
    
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sliderDidChange(_ sender: UISlider) {
        textFieldOutlet.text = "\(Int(sender.value))"
    }
    
    @objc func saveData() {
        let date:Date = datePickerOutlet.date
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "MMM dd, h:mm a"
        let dateTimeTemp = formatter.string(from: date)
        let tempResult = "Pumping: " + dateTimeTemp + " " + textFieldOutlet.text! + " ml"
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
