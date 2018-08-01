//
//  GraphsViewController.swift
//  firstbite
//
//  Created by Winston Ye on 2018-07-26.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Charts

class GraphsViewController: UIViewController {
    
    @IBOutlet weak var pieChart: PieChartView!
    var fstore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    // four food groups to be shown in the pie chart
    var milkEntry = PieChartDataEntry(value:0)
    var meatEntry = PieChartDataEntry(value:0)
    var vegfruitEntry = PieChartDataEntry(value:0)
    var grainEntry = PieChartDataEntry(value: 0)
    
    var meatCounter:Double = 0.0
    var vegfruitCounter:Double = 0.0
    var grainCounter:Double = 0.0
    var milkCounter:Double = 0.0
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    func updatePieChart(){
        let chartDataSet = PieChartDataSet(values:numberOfDownloadsDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
      //  chartDataSet.yValuePosition = .outsideSlice
        chartDataSet.entryLabelColor = UIColor.clear
        
        chartData.setValueTextColor(UIColor.black)
        chartData.setValueFont(UIFont(name:"boldSystemFontOfSize", size:24.0))
        let colors = [UIColor.blue, UIColor.cyan, UIColor.purple, UIColor.green]
        chartDataSet.colors = colors
        pieChart.data = chartData
        pieChart.chartDescription?.text = "Serving Representation of Food Groups"
        pieChart.drawHoleEnabled = false
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        fstore = Firestore.firestore()
        pieChart.noDataText = "No food log data available"
        milkEntry.label = "Milk & Alternatives"
        meatEntry.label = "Meat & Alternatives"
        vegfruitEntry.label = "Vegetable & Fruits"
        grainEntry.label = "Grains"
       
        fstore.collection(userID).whereField("Activity", isEqualTo: "Supplement").getDocuments(completion: {(snapshot, error) in
            for doc in (snapshot?.documents)! {
                switch (doc.data()["Food Category"] as! String){
                case "Meat/Alternatives" :
                    self.meatCounter+=1
                    break
                case "Vegetable/Fruit" :
                    self.vegfruitCounter+=1
                    break
                case "Milk/Alternatives" :
                    self.milkCounter+=1
                    break
                case "Grain" :
                    self.grainCounter+=1
                    break
                default : break
                }//end switch
            }
            self.milkEntry.value = self.milkCounter
            self.meatEntry.value = self.meatCounter
            self.vegfruitEntry.value = self.vegfruitCounter
            self.grainEntry.value = self.grainCounter
            self.numberOfDownloadsDataEntries = [self.milkEntry, self.meatEntry, self.vegfruitEntry, self.grainEntry]
            self.updatePieChart()
        })
    }
    
    @IBAction func pressInfo(_ sender: Any) {
        showAlert()
    }
    
    func showAlert(){
        let alert:UIAlertController = UIAlertController(title:"", message: "View the 'Food Suggestions' topic in our guide for suggested servings and recommendations.", preferredStyle: .alert )
        let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action1)
        self.present(alert,animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


