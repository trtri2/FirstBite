//
//  BreastfeedingDetailedViewController.swift
//  firstbite
//
//  Created by Han Yang on 7/25/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class BreastfeedingDetailedViewController: UIViewController {

    var datetimeText:String = ""
    var leftText:String = ""
    var rightText:String = ""
    var noteText:String = ""
    
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var lbLeft: UILabel!
    @IBOutlet weak var lbRight: UILabel!
    @IBOutlet var notesView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
//
//        lbDateTime.text = datetimeText
//        lbLeft.text = leftText
//        lbRight.text = rightText
//        lbNote.text = noteText
        
    }
    
    func setText(datetimeInput:String,leftInput:String,rightInput:String,noteInput:String) {
        datetimeText = datetimeInput
        leftText = leftInput
        rightText = rightInput
        noteText = noteInput
        
        if isViewLoaded{
            lbDateTime.text = datetimeInput
            lbLeft.text = leftInput
            lbRight.text = rightInput
            notesView.text = noteInput
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
