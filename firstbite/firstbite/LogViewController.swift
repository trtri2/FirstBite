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
import FirebaseAuth

// Functionality: the history log interface that will be used for all new logs
class LogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var logTable: UITableView!
    var data:[String] = []
    var selectedRow:Int = -1
    var dateActivityDict:[String:String] = [:]
    
    //Create Firestore variable
    var fstore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logTable.dataSource = self
        logTable.delegate = self
        self.title = "History Log"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
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
        cell.textLabel?.text = formatDate(d: data[indexPath.row])
        cell.imageView?.image = UIImage(named: dateActivityDict[data[indexPath.row]]!)
        return cell
    }
    
    //go to the detailed view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var activity:String = ""
        
        activity = dateActivityDict[data[indexPath.row]]!
        
            if activity == "Breastfeeding" {
                self.performSegue(withIdentifier: "breastfeeding", sender: nil)
            } else if activity == "Bottlefeeding" {
                self.performSegue(withIdentifier: "bottlefeeding", sender: nil)
            } else {
                self.performSegue(withIdentifier: "supplement", sender: nil)
            }
    }
    
    //prepare data to be displayed in the detailed view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var DictArray: [String:String] = [:];

        //get the index of the selected row
        selectedRow = logTable.indexPathForSelectedRow!.row

        //use the text in the table row to filter database info
        fstore.collection(userID).whereField("datetime", isEqualTo: data[selectedRow]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                DictArray = doc.data() as! [String : String]
            }
            
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
        })
    }

    //enable deleting feature in tableview
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        logTable.setEditing(editing, animated: animated)
    }
    
    //delete database entry, remove entry from data array, then remove row from table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        fstore.collection(userID).whereField("datetime", isEqualTo: data[indexPath.row]).getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                doc.reference.delete()
            }
        })
        data.remove(at: indexPath.row)
        logTable.deleteRows(at: [indexPath], with: .fade)
    }
    
    //load data from database and put into local array for tableview
    func load() {
        var loadedData:[String] = []
        var loadedDict:[String:String] = [:]
        
        fstore.collection(userID).whereField("isLog", isEqualTo: "true").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                loadedDict[doc.data()["datetime"] as! String] = doc.data()["Activity"] as? String
            }
            loadedData = [String](loadedDict.keys)
            self.data = loadedData.sorted().reversed()
            self.dateActivityDict = loadedDict
            self.logTable.reloadData()
        })
    }
    
    func formatDate(d:String) -> String {
        //convert data to a formatted date
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM d, h:mm a"
        var returnValue = ""

        if let date = inputDateFormatter.date(from: d) {
            returnValue = outputDateFormatter.string(from: date)
        }
        return returnValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

