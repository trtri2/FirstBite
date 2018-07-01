//
//  TrackLog.swift
//  firstbite
//
//  Created by Winston Ye on 6/29/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class TrackLog: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // labels
    @IBOutlet weak var formulaValue: UILabel!
    @IBOutlet weak var formulaUnit: UILabel!
    
    // unit of measurement picker
    @IBOutlet var pickerView: UIPickerView!
    
    // amount slider
    @IBOutlet weak var amountSlider: UISlider!
    
    // amount text field
    @IBOutlet weak var amountField: UITextField!

    
    let units = ["mL","oz"]
    
    var isMetric = true
    
    // setup start
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        amountField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return units[row]
    }
    
    // max length of text field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    //setup end
    
    // if a unit of measurement is selected, change the label as well
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(units[row] == "mL"){
            formulaUnit.text = "mL"
            amountSlider.maximumValue = 500
            isMetric = true
        }
        else if(units[row] == "oz"){
            formulaUnit.text = "oz"
            isMetric = false
            if(amountSlider.value >= 16.91){
                amountSlider.value = 16.91
                amountField.text = "16.91"
                formulaValue.text = "16.91"
            }
            amountSlider.maximumValue = 16.91
        }
    }


    // if slider moved
    @IBAction func sliderMoved(_ sender: UISlider) {
        if(isMetric == true){
            amountSlider.value = roundf(amountSlider.value / 5.0) * 5.0
        }
        let valueString = NSString(format: "%.2f", amountSlider.value) as String
        formulaValue.text = valueString
        amountField.text = valueString
    }

    // if text field changed
    @IBAction func textFieldChanged(_ sender: UITextField) {
        
        let floatAmount = Float(amountField.text!)
        
        // if the textfield is a valid float
        if(floatAmount != nil){
            if((floatAmount! >= 500)&&(isMetric)){
                formulaValue.text = "500"
            }
            else if((floatAmount! >= 16.91)&&(!isMetric)){
                formulaValue.text = "16.91"
            }
            else if(floatAmount! <= 0){
                formulaValue.text = "0"
            }
            else{
                // bug: leading zeroes, else good
                formulaValue.text = amountField.text
            }
             amountSlider.value = floatAmount!
        }
        
        // if the textfield is empty
        if(amountField.text! == ""){
            formulaValue.text = "0"
            amountSlider.value = 0
        }
    }
}

