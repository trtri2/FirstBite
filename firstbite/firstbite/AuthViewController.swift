//
//  AuthViewController.swift
//  firstbite
//
//  Created by Leon Trieu, Han Yang, Winston Ye, Jeff Wang, Kelvin Lee on 2018-07-24.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBtnLogin(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            if let email = tfEmail.text, let password = tfPassword.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
//                        self.btnLogin.setTitle("Logout", for: .normal)
                        self.performSegue(withIdentifier: "authed", sender: nil)
                    }
                    else {
                        self.showLoginAlert()
                    }
                })
            }
        }
    }
    
//    @IBAction func doBtnCreate(_ sender: Any) {
//        if let email = tfEmail.text, let password = tfPassword.text {
//            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//                if error == nil {
//                    self.performSegue(withIdentifier: "createAccount", sender: nil)
//                }
//                else if(email.count < 0){
//                    self.showCreateAlert()
//                }
//                else if(password.count < 5){
//                    self.showCreatePWAlert()
//                }
//                else {
//                    self.showCreateAlert()
//                }
//            })
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "authed", sender: nil)
        }
    }
    
    func showLoginAlert() {
        let alert:UIAlertController = UIAlertController(title: "Unable to login", message: "Incorrect username or password. Please try again", preferredStyle: .alert)
        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            (_:UIAlertAction) in
            print("cancel handler")
        }
        alert.addAction(action1)
        self.present(alert,animated:true) {
            print("alert handler")
        }
    }
    
    func showCreateAlert() {
        let alert:UIAlertController = UIAlertController(title: "Cannot Create User", message: "Check if your email is valid", preferredStyle: .alert)
        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            (_:UIAlertAction) in
            print("cancel handler")
        }
        alert.addAction(action1)
        self.present(alert,animated:true) {
            print("alert handler")
        }
    }
    
    // Functionality: invalid password alert
    func showCreatePWAlert() {
        let alert:UIAlertController = UIAlertController(title: "Cannot Create User", message: "Your password must contain 6 or more characters.", preferredStyle: .alert)
        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) {
            (_:UIAlertAction) in
            print("cancel handler")
        }
        alert.addAction(action1)
        self.present(alert,animated:true) {
            print("alert handler")
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
