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
        collectionName = "Guide"
        documentName = "Daily Food Suggestions"
        
        switch segue.identifier {
        case "dfs_6to9"? :
            article = "Food Suggestions: 6-9mo"
            break
        case "dfs_9to12"? :
            article = "Food Suggestions: 9-12mo"
            break
        case "dfs_12to24"? :
            article = "Food Suggestions: 12-24mo"
            break
        case "dfs_24to36"? :
            article = "Food Suggestions: 24-36mo"
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

