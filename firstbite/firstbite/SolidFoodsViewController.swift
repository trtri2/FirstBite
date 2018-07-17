//
//  SolidFoodsViewController.swift
//  firstbite
//
//  Created by thtrieu on 7/16/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//
// Swift file for dynamically changing the Solids Food Articles view controllers based on the article clicked.

import Foundation
import UIKit
import FirebaseFirestore

class SolidFoodsViewController: UITableViewController {

    var fstore: Firestore!

    override func viewDidLoad(){
        super.viewDidLoad()
        
        fstore = Firestore.firestore()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "solidFoodSegue", sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    let articleView:SolidFoodArticleViewController = segue.destination as! SolidFoodArticleViewController
       var regularText = ""
        if segue.identifier == "isf"{
            let docRef =  fstore.collection("Guide").document("Solid Foods")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A1_ISF"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })
            
        }
        if segue.identifier == "cff"{
            let docRef =  fstore.collection("Guide").document("Solid Foods")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A2_CFF"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })
            
        }
        if segue.identifier == "gsm"{
            let docRef =  fstore.collection("Guide").document("Solid Foods")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A3_GSM"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })
            
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
