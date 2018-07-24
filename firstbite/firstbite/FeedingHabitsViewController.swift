//
//  FeedingHabitsViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-17.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class FeedingHabitsViewController: UITableViewController {
    
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
        case "fh_6to9"? :
            collectionName = "Guide"
            documentName = "Feeding Habits"
            article = "A1_6to9"
            break
        case "fh_9to12"? :
            collectionName = "Guide"
            documentName = "Feeding Habits"
            article = "A2_9to12"
        case "fh_12to24"? :
            collectionName = "Guide"
            documentName = "Feeding Habits"
            article = "A3_12to24"
        case "fh_24to36"? :
            collectionName = "Guide"
            documentName = "Feeding Habits"
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

