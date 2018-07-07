//
//  LogViewController.swift
//  homework3
//
//  Created by Han Yang on 2018-06-30.
//  Copyright © 2018 Healthy 7 Group. All rights reserved.
//
//  bug fixed on 2018-07-03: now allows us to delete without trouble, previously couldn't

import UIKit

// Functionality: the history log interface that will be used for all new logs
class LogViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var logTable: UITableView!
    var data:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        logTable.dataSource = self
        self.title = "History Log"
   self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        logTable.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        logTable.deleteRows(at: [indexPath], with: .fade)
        UserDefaults.standard.set(data, forKey: "breastfeed")
    }
    
    func load() {
        if let loadedData:[String] = UserDefaults.standard.value(forKey: "breastfeed") as? [String] {
            data = loadedData.sorted()
            logTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

