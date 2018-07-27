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
    @IBOutlet weak var lbUnit: UILabel!
    @IBOutlet weak var lbReaction: UILabel!
    @IBOutlet weak var lbNotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.largeTitleDisplayMode = .never
        
        lbDateTime.text = datetimeText
        lbName.text = nameText
        lbCategory.text = categoryText
        lbQuantity.text = quantityText
        lbUnit.text = unitText
        lbReaction.text = reactionText
        lbNotes.text = noteText
    }
    
    func setText(datetimeInput:String,nameInput:String,categoryInput:String,quantityInput:String,unitInput:String,reactionInput:String,noteInput:String){
        
        datetimeText = datetimeInput
        nameText = nameInput
        categoryText = categoryInput
        quantityText = quantityInput
        unitText = unitInput
        reactionText = reactionInput
        noteText = noteInput
        
        if isViewLoaded{
            lbDateTime.text = datetimeInput
            lbName.text = nameInput
            lbCategory.text = categoryInput
            lbQuantity.text = quantityInput
            lbUnit.text = unitInput
            lbReaction.text = reactionInput
            lbNotes.text = noteInput
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
