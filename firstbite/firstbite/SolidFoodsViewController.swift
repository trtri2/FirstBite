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
        case "isf"? :
            collectionName = "Guide"
            documentName = "Solid Foods"
            article = "A1_ISF"
            break
        case "cff"? :
            collectionName = "Guide"
            documentName = "Solid Foods"
            article = "A2_CFF"
        case "gsm"? :
            collectionName = "Guide"
            documentName = "Solid Foods"
            article = "A3_GSM"
        case "fc"? :
            collectionName = "Guide"
            documentName = "Solid Foods"
            article = "A4_FC"
        default : break
                }
        
        let docRef =  fstore.collection(collectionName).document(documentName)
        docRef.getDocument(completion:{(snapshot, error) in
            if let document = snapshot?.data() {
                regularText = document[self.article] as! String
            }
            articleView.setText(t: regularText)
            articleView.setTitle(t:self.article)
        })
        

        
        
    }
}
