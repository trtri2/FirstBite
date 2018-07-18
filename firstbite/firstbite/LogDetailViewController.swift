//
//  LogDetailViewController.swift
//  firstbite
//
//  Created by Han Yang on 2018-07-14.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class LogDetailViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    var text:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        textView.text = text
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    func setText(t:String) {
        text = t
        //if view hasn't loaded yet, skip it. Let viewDidLoad handle the event
        if isViewLoaded{
            textView.text = t
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
