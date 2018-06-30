//
//  SecondViewController.swift
//  firstbite
//
//  Created by Han Yang on 6/29/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class TrackLog: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    // labels
    @IBOutlet weak var formulaValue: UILabel!
    @IBOutlet weak var formulaUnit: UILabel!
    
    // unit of measurement picker
    @IBOutlet weak var pickerView: UIPickerView!

    // amount slider
    @IBOutlet weak var amountSlider: UISlider!
    
    let units = ["mL","oz"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pickerView.delegate = self
        pickerView.dataSource = self
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
    
    
    // if a unit of measurement is selected, change the label as well
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(units[row] == "mL"){
            formulaUnit.text = "mL"
        }
        else if(units[row] == "oz"){
            formulaUnit.text = "oz"
        }
        print(units[row])
    }


    @IBAction func sliderMoved(_ sender: UISlider) {
        let valueString = NSString(format: "%.2f", amountSlider.value) as String
        formulaValue.text = valueString
    }
}

