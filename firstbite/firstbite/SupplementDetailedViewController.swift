//
//  SupplementDetailedViewController.swift
//  firstbite
//
//  Created by Han Yang on 7/25/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class SupplementDetailedViewController: UIViewController {
    
    var datetimeText:String = ""
    var nameText:String = ""
    var categoryText:String = ""
    var quantityText:String = ""
    var unitText:String = ""
    var reactionText:String = ""
    var noteText:String = ""
    
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbQuantity: UILabel!
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
        
//        lbDateTime.text = datetimeText
//        lbName.text = nameText
//        lbCategory.text = categoryText
//        lbQuantity.text = quantityText
//        lbUnit.text = unitText
//        lbReaction.text = reactionText
//        lbNotes.text = noteText
    }
    
    func setText(datetimeInput:String,nameInput:String,categoryInput:String,quantityInput:String,unitInput:String,reactionInput:String,noteInput:String){
        
//        datetimeText = datetimeInput
        nameText = nameInput
//        categoryText = categoryInput
//        quantityText = quantityInput
//        unitText = unitInput
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
            lbDateTime.text = datetimeInput
            lbName.attributedText = attributedText
            lbCategory.text = categoryInput
            lbQuantity.text = quantityInput + unitInput
            lbReaction.text = reactionText
            notesView.text = noteInput
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//["datetime":dataTextField.text!,"Activity":"Supplement","Food Name":foodTextFieldOutlet.text!,"Food Category":categoryTypeString,"Quantity":quantityTextFieldOutlet.text!,"Quantity Unit":quantityUnitString,"Notes":tempNotes,"Reaction":reaction]
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
