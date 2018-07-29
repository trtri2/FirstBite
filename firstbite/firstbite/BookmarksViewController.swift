//
//  BookmarksViewController.swift
//  firstbite
//
//  Created by Winston Ye, Leon Trieu on 7/3/18.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Foundation

// Functionality: used to add and manage bookmarks from the Guidebook
class BookmarksViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bookmarkTable: UITableView!
    var data:[String] = []
    var selectedRow:Int = -1
    var fstore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bookmarkTable.dataSource = self
        bookmarkTable.delegate = self
        self.title = "Bookmarks"
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
        
        fstore = Firestore.firestore()
    
        load()
    }
    
    //reload data whenever the bookmark view should be displayed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //go to the bookmark page view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "bookmarkSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let articleView:BookmarkArticleView = segue.destination as! BookmarkArticleView
        var regularText = ""
        
        selectedRow = bookmarkTable.indexPathForSelectedRow!.row
        
        let docRef =  fstore.collection(userID).document("Bookmarks Log").collection("Bookmarks").document(data[selectedRow])
        docRef.getDocument(completion:{(snapshot, error) in
            if let doc = snapshot?.data(){
                regularText = doc["displayText"] as! String
            }
            articleView.setText(t: regularText)
        })
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        bookmarkTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        fstore.collection(userID).document("Bookmarks Log").collection("Bookmarks").document(data[indexPath.row]).delete()

        data.remove(at: indexPath.row)
        bookmarkTable.deleteRows(at: [indexPath], with: .fade)
        //UserDefaults.standard.set(data, forKey: "breastfeed")
    }
    
    func load() {
        var loadedData:[String] = []
        fstore.collection(userID).document("Bookmarks Log").collection("Bookmarks").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                loadedData.insert(doc.documentID , at: 0)
            }
            self.data = loadedData.sorted()
            self.bookmarkTable.reloadData()
        })
    }
    
    
}

