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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "logSegue", sender: nil)
        selectedRow = logTable.indexPathForSelectedRow!.row
        fstore.collection("Log").whereField("datetime", isEqualTo: data[selectedRow]).getDocuments(completion: {(snapshot, error) in
                for doc in (snapshot?.documents)! {
                    print(doc.data())
                }
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let detailView:LogDetailViewController = segue.destination as! LogDetailViewController
//        selectedRow = logTable.indexPathForSelectedRow!.row
//
//        var textArray: [String:Any] = [:];
//        var textString: String = ""
//
//        fstore.collection("Log").whereField("datetime", isEqualTo: data[selectedRow]).getDocuments(completion: {(snapshot, error) in
//            for doc in (snapshot?.documents)! {
//                textArray = doc.data()
//            }
//            textString = textArray
//        })
//        detailView.setText(t: data[selectedRow])
//    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        logTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        logTable.deleteRows(at: [indexPath], with: .fade)
        //UserDefaults.standard.set(data, forKey: "breastfeed")
    }
    
    func load() {
        //if let loadedData:[String] = UserDefaults.standard.value(forKey: "breastfeed") as? [String] {
        var loadedData:[String] = []
        fstore.collection("Log").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                loadedData.insert(doc.data()["datetime"] as! String, at: 0)
            }
            self.data = loadedData.sorted()
            //self.logTable.reloadData()
        })
//        data = loadedData.sorted()
        logTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

