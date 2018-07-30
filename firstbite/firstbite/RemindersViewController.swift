//
//  RemindersViewController.swift
//  firstbite
//
//  Created by Winston Ye on 2018-07-28.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RemindersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var tableView: UITableView!
    var data: [String] = [];
    var selectedRow:Int = -1
    
    //Create Firestore variable
    var fstore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        self.title = "Reminders"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        //initiate Firestore
        fstore = Firestore.firestore()
        load()
    }
    
    //reload data whenever the log view should be displayed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    //number of rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //set title in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]

        return cell
    }
    
    //selected tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    //enable deleting feature in tableview
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    //delete database entry, remove entry from data array, then remove row from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fstore.collection("Log").whereField("datetime", isEqualTo: data[indexPath.row]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                doc.reference.delete()
            }
        })
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //load data from database and put into local array for tableview
    func load() {
        var loadedData:[String] = []
        var loadedDict:[String:String] = [:]
        
        fstore.collection("Log").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                loadedDict[doc.data()["datetime"] as! String] = doc.data()["Reminder"] as? String
            }
            loadedData = [String](loadedDict.keys)
            self.data = loadedData.sorted()
//            self.dateActivityDict = loadedDict
            self.tableView.reloadData()
        })
    }

}
