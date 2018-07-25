//
//  AuthViewController.swift
//  firstbite
//
//  Created by Leon Trieu, Han Yang, Winston Ye, Jeff Wang, Kelvin Lee on 2018-07-24.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBtnLogin(_ sender: Any) {
    }
    
    @IBAction func doBtnCreate(_ sender: Any) {
        if let email = tfEmail.text, let password = tfPassword.text {
            
        }
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
