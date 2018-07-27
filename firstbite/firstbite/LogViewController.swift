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
        var imageName: String = ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        fstore.collection("Log").whereField("datetime", isEqualTo: data[indexPath.row]).getDocuments {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                imageName = doc.data()["Activity"] as! String
            }
//            cell.imageView?.image = UIImage(named: imageName)
        }
//        cell.imageView?.image = UIImage(named: imageName)
        return cell
    }
    
    //go to the detailed view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var activity:String = ""
//        var DictArray: [String:String] = [:]
        fstore.collection("Log").whereField("datetime", isEqualTo: data[indexPath.row]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                activity = doc.data()["Activity"] as! String
            }
            
            if activity == "Breastfeeding" {
                self.performSegue(withIdentifier: "breastfeeding", sender: nil)
            } else if activity == "Bottlefeeding" {
                self.performSegue(withIdentifier: "bottlefeeding", sender: nil)
            } else {
                self.performSegue(withIdentifier: "supplement", sender: nil)
            }
        })
    }
    
    //prepare data to be displayed in the detailed view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var DictArray: [String:String] = [:];
//        var textString: String = ""

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
                let breastfeedDetailView:BreastfeedingDetailedViewController = segue.destination as! BreastfeedingDetailedViewController
                breastfeedDetailView.setText(datetimeInput: DictArray["datetime"]!, leftInput: DictArray["Left Timer"]!, rightInput: DictArray["Right Timer"]!, noteInput: DictArray["Notes"]!)
            } else if DictArray["Activity"] == "Bottlefeeding" {
                let bottlefeedDetailView:BottlefeedingDetailedViewController = segue.destination as! BottlefeedingDetailedViewController
                bottlefeedDetailView.setText(datetimeInput: DictArray["datetime"]!, nameInput: DictArray["Formula Name"]!, amountInput: DictArray["Formula Amount"]!, reactionInput: DictArray["Reaction"]!, noteInput: DictArray["Notes"]!)
            } else {
                let supplementDetailView:SupplementDetailedViewController = segue.destination as! SupplementDetailedViewController
                supplementDetailView.setText(datetimeInput: DictArray["datetime"]!, nameInput: DictArray["Food Name"]!, categoryInput: DictArray["Food Category"]!, quantityInput: DictArray["Quantity"]!, unitInput: DictArray["Quantity Unit"]!, reactionInput: DictArray["Reaction"]!, noteInput: DictArray["Notes"]!)
            }
//            detailView.setText(t: textString)
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

