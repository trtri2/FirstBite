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
       var htmlText = ""
        if segue.identifier == "isf"{
            let docRef =  fstore.collection("Guide").document("Solid Foods")
            docRef.getDocument(completion:{(snapshot, error) in
                if let document = snapshot?.data() {
                    htmlText = document["A1_ISF"] as! String
                }
                articleView.setText(t: htmlText)
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

//let htmlTest = "<h1><strong>Introducing Solid Foods</strong></h1>        <p>The World Health Organization, Health Canada, Dietitians of Canada,&nbsp;the Canadian Paediatric&nbsp;Society and the Breastfeeding Committee of Canada recommend that when your toddler is six months old, you keep breastfeeding but also offer solid foods.</p><p>You will know she is ready for solid food when she:</p><ul><li>Sits and holds her head up.</li><li>Watches and opens her mouth for a spoon and closes her lips around the spoon.</li><li>Does not push food out of her mouth with her tongue.<strong><br /></strong></li></ul><p>To get started, pick a time when your toddler is alert and has an appetite but is not too hungry. Seat him on your lap or facing you while secured in a comfortable high chair. It is a good idea to give him a second child-sized spoon. That way he is less likely to grab your spoon.</p><p>Place a spoonful of meat or iron-fortified infant cereal close to his lips. Give him time to look at it, smell it and taste it. Once he opens his mouth, put the spoon in. If he takes the food, offer another spoonful. If he spits out the food, wait a few minutes and try again.</p><p>You can expect that most of the first solid food you offer will end up on his bib, face and high-chair tray.</p><p><em>This is normal &ndash; you are getting him used to&nbsp;eating solid foods.</em></p>"
//
//textTest.attributedText = htmlTest.htmlToAttributedString

