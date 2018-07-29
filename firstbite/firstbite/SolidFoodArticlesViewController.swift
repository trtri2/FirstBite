//
//  SolidFoodArticlesViewController.swift
//  firstbite
//
//  Created by thtrieu on 7/16/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class SolidFoodArticleViewController: UIViewController{
    
    
    
    var fstore: Firestore!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var text = ""
    var tempTitle = ""
    var displayText = NSAttributedString()
    var userID = Auth.auth().currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.attributedText = displayText
        fstore = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func bookmarkThis(_ sender: Any) {
        
        // creating alert popup
        let bmalert = UIAlertController(title:"Add this page to bookmarks?", message:"View bookmarks on the bookmarks table", preferredStyle:UIAlertControllerStyle.alert)
        
        // adding button options (two)
        bmalert.addAction(UIAlertAction(title:"Bookmark", style:UIAlertActionStyle.default, handler: { action in
            
            //save html string into bookmark collection
            self.fstore.collection(self.userID).document("Bookmarks Log").collection("Bookmarks").document(self.tempTitle).setData(["displayText":self.text], merge : true)
        
        }))
        bmalert.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
        
        // show the popup
        self.present(bmalert, animated:true, completion:nil)
        
    }
    
    // save the title of the article
    func setTitle(t:String){
        tempTitle = t
        print(tempTitle)
    }
    
    // set displayed text
    func setText(t:String) {
        text = t
        displayText = t.htmlToAttributedString!
        if isViewLoaded{
            textView.attributedText = displayText
        }
    }
    
}



// extension to convert String of HTML to a displayable NSAttributedString.
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do { return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
        } catch { return NSAttributedString()
        }
    }
    var htmlToString: String { return htmlToAttributedString?.string ?? "" }
    
}

