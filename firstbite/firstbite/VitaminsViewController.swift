//
//  VitaminsViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-28.
//  Copyright © 2018 Healthy7. All rights reserved.
//
//
import Foundation
import UIKit
import FirebaseFirestore

class VitaminsViewController: UITableViewController {
    
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
        documentName = "Vitamins & Supplements"
        
        switch segue.identifier {
        case "vitd"? :
            article = "Vitamin D"
            break
        case "iron"? :
            article = "Iron"
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

