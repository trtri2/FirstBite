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
    @IBOutlet var notesView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
        // not needed?
//        lbDateTime.text = datetimeText
//        lbAmount.text = amountText + "mL"
//        lbReaction.text = reactionText
//        lbNotes.text = noteText
        
    }
    
    func setText(datetimeInput:String,nameInput:String,amountInput:String,reactionInput:String,noteInput:String){
//        datetimeText = datetimeInput
        nameText = nameInput
//        amountText = amountInput
        reactionText = reactionInput
//        noteText = noteInput
        
        // for underlining name
        let textRange = NSRange(location: 0, length: (nameText.count))
        let attributedText = NSMutableAttributedString(string: nameText)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        
        if(reactionText == "Good"){
            reactionText = "🤤"
        }
        else if(reactionText == "Bad"){
            reactionText = "😧"
        }
        else{
            reactionText = "😐"
        }
        
        if isViewLoaded{
            lbName.attributedText = attributedText
            lbDateTime.text = datetimeInput
            lbAmount.text = amountInput + "mL"
            lbReaction.text = reactionText
            notesView.text = noteInput
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
