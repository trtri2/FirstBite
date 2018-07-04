//
//  BookmarksViewController.swift
//  firstbite
//
//  Created by Winston Ye, Leon Trieu on 7/3/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

// Functionality: used to add and manage bookmarks from the Guidebook
class BookmarksViewController: UITableViewController {
 let myarray = ["Bookmark 1", "Bookmark 2", "Bookmark 3"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myarray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier:"bookmarksCell")
        cell.textLabel?.text = myarray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "solidfood") as UIViewController
        
        self.present(viewController, animated: false, completion: nil)
    }
}

