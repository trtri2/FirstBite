//
//  FormulaTestViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-16.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do { return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
        } catch { return NSAttributedString()
        }
    }
    var htmlToString: String { return htmlToAttributedString?.string ?? "" }
    
}


class FormulaTestViewController: UIViewController {
    
   
    @IBOutlet weak var textTest: UITextView!
    override func viewDidLoad() {
        let htmlTest = "<h1><strong>Introducing Solid Foods</strong></h1>        <p>The World Health Organization, Health Canada, Dietitians of Canada,&nbsp;the Canadian Paediatric&nbsp;Society and the Breastfeeding Committee of Canada recommend that when your toddler is six months old, you keep breastfeeding but also offer solid foods.</p><p>You will know she is ready for solid food when she:</p><ul><li>Sits and holds her head up.</li><li>Watches and opens her mouth for a spoon and closes her lips around the spoon.</li><li>Does not push food out of her mouth with her tongue.<strong><br /></strong></li></ul><p>To get started, pick a time when your toddler is alert and has an appetite but is not too hungry. Seat him on your lap or facing you while secured in a comfortable high chair. It is a good idea to give him a second child-sized spoon. That way he is less likely to grab your spoon.</p><p>Place a spoonful of meat or iron-fortified infant cereal close to his lips. Give him time to look at it, smell it and taste it. Once he opens his mouth, put the spoon in. If he takes the food, offer another spoonful. If he spits out the food, wait a few minutes and try again.</p><p>You can expect that most of the first solid food you offer will end up on his bib, face and high-chair tray.</p><p><em>This is normal &ndash; you are getting him used to&nbsp;eating solid foods.</em></p>"
        
        textTest.attributedText = htmlTest.htmlToAttributedString

        super.viewDidLoad()
   
   
   
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
