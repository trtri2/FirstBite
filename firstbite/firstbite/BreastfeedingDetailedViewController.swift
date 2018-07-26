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
    @IBOutlet weak var lbNote: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    func setText(t:String) {
        
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
