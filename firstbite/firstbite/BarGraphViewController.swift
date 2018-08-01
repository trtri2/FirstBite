//
//  BarGraphViewController.swift
//  firstbite
//
//  Created by Leon Trieu on 2018-07-31.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Charts

class BarGraphViewController: UIViewController {
    

@IBOutlet weak var barChart: BarChartView!
    
var goodCounter:Double = 0.0
var badCounter:Double = 0.0
var neutralCounter:Double = 0.0
var reactions = ["😧","😐","🤤"]
var reactionCount: [Double] = []

var fstore: Firestore!
var userID = Auth.auth().currentUser!.uid

func updateBarChart(dataPoints: [String], values: [Double]){
    var dataEntries: [BarChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
        let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
        dataEntries.append(dataEntry)
        
    }
    
    let chartDataSet = BarChartDataSet(values: dataEntries, label: "Count of Reactions")
    let chartData = BarChartData()
    chartData.addDataSet(chartDataSet)
    chartDataSet.colors = [UIColor.yellow, UIColor.blue, UIColor.green]
    barChart.leftAxis.enabled = false
    barChart.rightAxis.enabled = false
    barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:reactions)
    barChart.xAxis.granularity = 1
    barChart.xAxis.labelFont = UIFont(name:"Helvetica", size: 25.0)!
    barChart.data = chartData
    barChart.legend.enabled = false
    barChart.chartDescription?.text = "Representation of Food Reactions"
}

    @IBAction func pressInfo(_ sender: Any) {
        showAlert()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        fstore = Firestore.firestore()
        //////bar chart collection code
        fstore.collection(userID).whereField("hasReaction", isEqualTo: "true").getDocuments(completion:{(snapshot, error) in
            for doc in (snapshot?.documents)!{
                let tempReaction = doc.data()["Reaction"] as! String
                switch (tempReaction){
                case "Neutral" :
                    self.neutralCounter+=1
                    break
                case "Good" :
                    self.goodCounter+=1
                    break
                case "Bad" :
                    self.badCounter+=1
                    break
                default : break
                }//end switch
            }
            self.reactionCount.append(self.badCounter)
            self.reactionCount.append(self.neutralCounter)
            self.reactionCount.append(self.goodCounter)
            self.updateBarChart(dataPoints: self.reactions, values: self.reactionCount)
        })
    }
    
    func showAlert(){
        let alert:UIAlertController = UIAlertController(title:"", message: "Children may need more than one exposure to a food to determine whether they like it or not", preferredStyle: .alert )
         let action1: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action1)
        self.present(alert,animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
