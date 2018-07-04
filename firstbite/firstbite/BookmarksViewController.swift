//
//  BookmarksViewController.swift
//  firstbite
//
//  Created by winstony on 7/3/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit

class BookmarksViewController: UITableViewController {
 let myarray = ["apple", "banana", "cantaloupe"]
 
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
        cell.textLabel?.text = myarray[indexPath.item]
        return cell
    }
}

