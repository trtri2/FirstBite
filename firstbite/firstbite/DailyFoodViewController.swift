//
//  DailyFoodViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class DailyFoodViewController: UITableViewController {
    
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
        case "dfs_6to9"? :
            collectionName = "Guide"
            documentName = "Daily Food Suggestions"
            article = "A1_6to9"
            break
        case "dfs_9to12"? :
            collectionName = "Guide"
            documentName = "Daily Food Suggestions"
            article = "A2_9to12"
        case "dfs_12to24"? :
            collectionName = "Guide"
            documentName = "Daily Food Suggestions"
            article = "A3_12to24"
        case "dfs_24to36"? :
            collectionName = "Guide"
            documentName = "Daily Food Suggestions"
            article = "A4_24to36"
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

