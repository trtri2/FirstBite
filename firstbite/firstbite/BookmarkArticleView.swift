//
//  BookmarkArticleView.swift
//  BoringSSL
//
//  Created by Leon Trieu on 2018-07-26.
//

import Foundation
import UIKit
import FirebaseFirestore

class BookmarkArticleView: UIViewController {
    
    @IBOutlet weak var displayText: UITextView!
    var fstore: Firestore!
    var articleText = NSAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayText.attributedText = articleText
        fstore = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText(t:String){
        articleText = t.htmlToAttributedString!
        if isViewLoaded{
            displayText.attributedText = articleText
        }
    }
    
}
