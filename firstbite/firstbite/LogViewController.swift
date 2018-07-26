//
//  LogViewController.swift
//  homework3
//
//  Created by Han Yang on 2018-06-30.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//
//  bug fixed on 2018-07-03: now allows us to delete without trouble, previously couldn't

import UIKit
import FirebaseFirestore

// Functionality: the history log interface that will be used for all new logs
class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var logTable: UITableView!
    var data:[String] = []
    var selectedRow:Int = -1
    
    //Create Firestore variable
    var fstore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logTable.dataSource = self
        logTable.delegate = self
        self.title = "History Log"
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
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    //go to the detailed view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "logSegue", sender: nil)
    }
    
    //prepare data to be displayed in the detailed view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:LogDetailViewController = segue.destination as! LogDetailViewController
        
        var DictArray: [String:String] = [:];
        var textString: String = ""
        
        //get the index of the selected row
        selectedRow = logTable.indexPathForSelectedRow!.row

        //use the text in the table row to filter database info
        fstore.collection("Log").whereField("datetime", isEqualTo: data[selectedRow]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                DictArray = doc.data() as! [String : String]
            }
            //var selectedArray = [String](DictArray.values)
            //var numberInArry = DictArray.count
//            for (key, value) in DictArray {
//                textString += "\(key) : \(value)\n"
//            }
            if DictArray["Activity"] == "Breastfeeding" {
                
            }
            detailView.setText(t: textString)
        })
    }
    
    //enable deleting feature in tableview
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        logTable.setEditing(editing, animated: animated)
    }
    
    //delete database entry, remove entry from data array, then remove row from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fstore.collection("Log").whereField("datetime", isEqualTo: data[indexPath.row]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                doc.reference.delete()
            }
        })
        data.remove(at: indexPath.row)
        logTable.deleteRows(at: [indexPath], with: .fade)
        //UserDefaults.standard.set(data, forKey: "breastfeed")
    }
    
    //load data from database and put into local array for tableview
    func load() {
        //if let loadedData:[String] = UserDefaults.standard.value(forKey: "breastfeed") as? [String] {
        var loadedData:[String] = []
        fstore.collection("Log").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                loadedData.insert(doc.data()["datetime"] as! String, at: 0)
            }
            self.data = loadedData.sorted()
            self.logTable.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

