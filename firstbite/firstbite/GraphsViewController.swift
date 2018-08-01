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
    @IBOutlet weak var barChart: BarChartView!
    
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
   
    //// bar chart vars
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
        chartDataSet.colors = [UIColor.blue]
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:reactions)
        barChart.xAxis.granularity = 1
        barChart.data = chartData
    }
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fstore = Firestore.firestore()
        pieChart.chartDescription?.text = "Food Proportions in Servings"

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
        //////bar chart collection code
        fstore.collection(userID).whereField("isLog", isEqualTo: "true").getDocuments(completion:{(snapshot, error) in
            for doc in (snapshot?.documents)!{
                switch (doc.data()["Reaction"] as! String){
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


