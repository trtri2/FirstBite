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
        collectionName = "Guide"
        documentName = "Solid Foods"
        switch segue.identifier {
            
        case "isf"? :
            article = "Introducing Solid Foods"
            break
        case "cff"? :
            article = "Choosing a First Food"
            break
        case "gsm"? :
            article = "Getting Started with Meat"
            break
        case "fc"? :
            article = "Food Choices"
            break
        case "f&s"? :
            article = "Fish & Seafood"

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
