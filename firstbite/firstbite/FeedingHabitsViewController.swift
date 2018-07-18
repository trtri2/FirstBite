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
        if segue.identifier == "fh_6to9"{
            let docRef =  fstore.collection("Guide").document("Feeding Habits")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A1_6to9"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })
            
        }
        if segue.identifier == "fh_9to12"{
            let docRef =  fstore.collection("Guide").document("Feeding Habits")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A2_9to12"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })	
            
        }
        if segue.identifier == "fh_12to24"{
            let docRef =  fstore.collection("Guide").document("Feeding Habits")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    regularText = document["A3_12to24"] as! String
                }
                let htmlText = regularText.htmlToAttributedString
                articleView.setText(t: htmlText!)
            })
            
        }
        
        
    }
}

