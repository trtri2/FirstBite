//
//  MindfulEatingViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-28.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

class MindfulEatingViewController: UITableViewController {
    
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
        documentName = "Mindful Eating"
        
        switch segue.identifier {
        case "dsam"? :
            article = "Don't Stress About the Mess"
            break
        case "fc"? :
            article = "Feeding Cues"
            break
        case "fj"? :
            article = "Feeding Jobs"
            break
        case "et"? :
            article = "Eating Together"
            break
        case "ppe"? :
            article = "Preventing Picky Eating"
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

