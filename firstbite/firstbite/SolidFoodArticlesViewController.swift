//
//  SolidFoodArticlesViewController.swift
//  firstbite
//
//  Created by thtrieu on 7/16/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit

class SolidFoodArticleViewController: UIViewController{
    
    
    @IBOutlet weak var textView: UITextView!
    var text:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setText(t:String) {
        text = t
        if isViewLoaded{
            textView.text = t
        }
    }
    
}
