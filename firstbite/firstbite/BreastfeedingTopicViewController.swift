//
//  BreastfeedingTopicViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-18.
//  Copyright © 2018 Healthy7. All rights reserved.
//


import Foundation
import UIKit
import FirebaseFirestore

class BreastfeedingTopicViewController: UITableViewController {
    
    var fstore: Firestore!
    var collectionName = ""
    var documentName = ""
    var article = ""
    
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
        
        
        switch segue.identifier {
        case "bb"? :
            collectionName = "Guide"
            documentName = "Breastfeeding"
            article = "A1_BB"
            break
        case "weaning"? :
            collectionName = "Guide"
            documentName = "Breastfeeding"
            article = "A2_WEANING"
        case "faq_breastfeeding"? :
            collectionName = "Guide"
            documentName = "Breastfeeding"
            article = "A3_FAQ"

        default : break
        }
        
        let docRef =  fstore.collection(collectionName).document(documentName)
        docRef.getDocument(completion:{(snapshot, error) in
            if let document = snapshot?.data() {
                regularText = document[self.article] as! String
            }
            let htmlText = regularText.htmlToAttributedString
            articleView.setText(t: htmlText!)
        })
        
    }
}

