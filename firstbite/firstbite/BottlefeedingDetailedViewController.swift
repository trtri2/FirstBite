//
//  BottlefeedingDetailedViewController.swift
//  firstbite
//
//  Created by Han Yang on 7/25/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class BottlefeedingDetailedViewController: UIViewController {
    
    var datetimeText:String = ""
    var nameText:String = ""
    var amountText:String = ""
    var reactionText:String = ""
    var noteText:String = ""
    
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbReaction: UILabel!
    @IBOutlet weak var lbNotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
        
        lbDateTime.text = datetimeText
        lbName.text = nameText
        lbAmount.text = amountText
        lbReaction.text = reactionText
        lbNotes.text = noteText
        
    }
    
    func setText(datetimeInput:String,nameInput:String,amountInput:String,reactionInput:String,noteInput:String){
        datetimeText = datetimeInput
        nameText = nameInput
        amountText = amountInput
        reactionText = reactionInput
        noteText = noteInput
        
        if isViewLoaded{
            lbDateTime.text = datetimeInput
            lbName.text = nameInput
            lbAmount.text = amountInput
            lbReaction.text = reactionInput
            lbNotes.text = noteInput
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//["datetime":dataTextField.text!,"Activity":"Bottlefeeding","Formula Name":formulaTextFieldOutlet.text!,"Formula Amount":amountTextFieldOutlet.text!,"Notes":tempNotes, "Reaction":reaction]
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
