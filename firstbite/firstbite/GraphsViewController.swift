//
//  GraphsViewController.swift
//  firstbite
//
//  Created by Winston Ye on 2018-07-26.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import Charts

class GraphsViewController: UIViewController {
    
     var numbers : [Double] = [25.2, 10, 3, 5, 6]
    
    @IBOutlet var chtChart: LineChartView!
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var iosStepper: UIStepper!
    @IBOutlet weak var macStepper: UIStepper!
    
    var iosDataEntry = PieChartDataEntry(value: 0)
    var macDataEntry = PieChartDataEntry(value: 0)
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }
    
    @IBAction func changeiOS(_ sender: UIStepper) {
        iosDataEntry.value = sender.value
        updateChartData()
    }
    
    @IBAction func changeMac(_ sender: UIStepper) {
        macDataEntry.value = sender.value
        updateChartData()
    }
    
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: numberOfDownloadsDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.blue, UIColor.red]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChart.chartDescription?.text = ""
        
        iosDataEntry.value = iosStepper.value
        iosDataEntry.label = "herb"
        
        macDataEntry.value = macStepper.value
        macDataEntry.label = "gerry"
        
        numberOfDownloadsDataEntries = [iosDataEntry, macDataEntry]
        
        updateChartData()
        updateGraph()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
