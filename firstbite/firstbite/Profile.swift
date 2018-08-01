//
//  Profile.swift
//  firstbite
//
//  Created by Kelvin Lee on 2018-07-16.
//  Copyright © 2018 Healthy7. All rights reserved.
//

import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth

class Profile: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var firestore: Firestore!
    var userID = Auth.auth().currentUser!.uid
    
    //Creating variables
    var UserName = ""
    var UserChildName = ""
    var UserChildGender = ""
    var weightArr: [Int] = []
    var heightArr: [Int] = []
    
    var heightsMonthsArr: [Int] = []
    var weightsMonthsArr: [Int] = []
    
    var image = UIImagePickerController()
    var UserChildBirthYear = Int()
    var UserChildBirthMonth = Int()
    var UserChildBirthDay = Int()
    var UserChildAge = Int()
    
    // graphics
    @IBOutlet var childPicture: UIImageView!
    @IBOutlet var gradientLayer: UIView!
    
    // charts
    @IBOutlet var heightChartView: LineChartView!
    @IBOutlet var weightChartView: LineChartView!
    
    //Display User's Child
    @IBOutlet weak var displayWhoseChild: UILabel!
    func WhoseChild() {
        displayWhoseChild.text = UserName + "'s baby"
    }
    
    //Display Child's name
    @IBOutlet weak var displayChildName: UILabel!
    func ChildName() {
        if(UserChildName == ""){
            displayChildName.text = UserName + "'s baby"
        }
        else{
            displayChildName.text = UserChildName
        }
    }
    
    //Display Child's age
    @IBOutlet weak var displayChildAge: UILabel!
    func ChildAge(_ age: inout Int) {
        let date = Date()
        let calendar = Calendar.current
        
        var monthString: String = " months"
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        if month >= UserChildBirthMonth {
            age = 12 * (year - UserChildBirthYear) + (month - UserChildBirthMonth)
        }
        else {
            age = 12 * (year - UserChildBirthYear) + (UserChildBirthMonth - month)
        }
        
        if(age <= 1){
            monthString = " month"
        }
        
        displayChildAge.text = String(age) + monthString
    }
    
    //Display Child's gender
    @IBOutlet weak var displayChildGender: UILabel!
    func ChildGender() {
        displayChildGender.text = UserChildGender
    }
    
    //Display Child's Pictures
    @IBOutlet weak var displayChildPicture: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Save Image in Persistence
            let imageData:NSData = UIImageJPEGRepresentation(image, 1)! as NSData
            UserDefaults.standard.set(imageData, forKey: "savedImage")
            let data = UserDefaults.standard.object(forKey: "savedImage") as! NSData
            displayChildPicture.image = UIImage(data: data as Data)
            
        }
        else {
            // Error
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Import from Library
    @IBAction func importFromLibrary(_ sender: Any) {
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it is complete
        }
    }
    
    
    //Import from Camera
    @IBAction func importFromCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    // Display Add Height Alert
    @IBAction func pressedAddHeight(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "Height (cm)", message: "Add a height to the growth chart.", preferredStyle: .alert)
    
        // height field
        alert.addTextField { (textField) in
            textField.placeholder = "Height" // default text field
            textField.delegate = self as? UITextFieldDelegate
            textField.keyboardType = .numberPad
        }
        
        // month field
        alert.addTextField { (textField) in
            textField.placeholder = "Months old" // default text field
            textField.delegate = self as? UITextFieldDelegate
            textField.keyboardType = .numberPad
        }
        
        // add button
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let heightField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let monthField = alert?.textFields![1]
            
            var heightVal: Int = 0
            var monthVal: Int = 0
            
            // if user sets empty string in either field
            if(heightField?.text == ""){
                heightVal = 0
            }
            else{
                heightVal = Int(heightField!.text!)!
            }
            
            if(monthField?.text == ""){
                monthVal = 0
            }
            else{
                monthVal = Int(monthField!.text!)!
            }
            
            self.updateHeight(newHeight: heightVal, newMonth: monthVal)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Display Add Weight Alert
    @IBAction func pressedAddWeight(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "Weight (kg)", message: "Add a weight to the growth chart.", preferredStyle: .alert)
        
        // weight field
        alert.addTextField { (textField) in
            textField.placeholder = "Weight" // default text field
            textField.delegate = self as? UITextFieldDelegate
            textField.keyboardType = .numberPad
        }
        
        // month field
        alert.addTextField { (textField) in
            textField.placeholder = "Months old" // default text field
            textField.delegate = self as? UITextFieldDelegate
            textField.keyboardType = .numberPad
        }
        
        // add button
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let weightField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let monthField = alert?.textFields![1]
            
            var weightVal: Int = 0
            var monthVal: Int = 0
            
            // if user sets empty string in either field
            if(weightField?.text == ""){
                weightVal = 0
            }
            else{
                weightVal = Int(weightField!.text!)!
            }
            
            if(monthField?.text == ""){
                monthVal = 0
            }
            else{
                monthVal = Int(monthField!.text!)!
            }
            
            self.updateWeight(newWeight: weightVal, newMonth: monthVal)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Update Child_heights array witihn user's database
    func updateHeight(newHeight: Int, newMonth: Int){
        let doc = firestore.collection(userID).document("Profile")
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data(){
                var tempHeightsArr = d["Child_heights"] as! Array<Int>
                var tempHeightsMonthsArr = d["Heights_months"] as! Array<Int>
                
                tempHeightsArr.append(newHeight)
                tempHeightsMonthsArr.append(newMonth)
                
                doc.updateData(["Child_heights": tempHeightsArr])
                doc.updateData(["Heights_months": tempHeightsMonthsArr])
                
                // update global arr, then update charts
                self.heightArr = tempHeightsArr
                self.heightsMonthsArr = tempHeightsMonthsArr
                self.updateHeightChart()
            }
        })
    }
    
    // Update Child_weights array witihn user's database
    func updateWeight(newWeight: Int, newMonth: Int){
        let doc = firestore.collection(userID).document("Profile")
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data(){
                var tempWeightsArr = d["Child_weights"] as! Array<Int>
                var tempWeightsMonthsArr = d["Weights_months"] as! Array<Int>
                
                tempWeightsArr.append(newWeight)
                tempWeightsMonthsArr.append(newMonth)
                
                doc.updateData(["Child_weights": tempWeightsArr])
                 doc.updateData(["Weights_months": tempWeightsMonthsArr])
                
                // update global arr, then update charts
                self.weightArr = tempWeightsArr
                self.weightsMonthsArr = tempWeightsMonthsArr
                self.updateWeightChart()
            }
        })
    }
    
    // Update Height Chart
    func updateHeightChart(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<heightArr.count {
            
            let value = ChartDataEntry(x: Double(heightsMonthsArr[i]), y: Double(heightArr[i])) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Height(cm)") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        heightChartView.xAxis.axisMaximum = 24
        
        heightChartView.xAxis.axisMinimum = 0
        
        heightChartView.data = data //finally - it adds the chart data to the chart and causes an update
        
        heightChartView.chartDescription?.text = "Height Line Chart" // Here we set the description for the graph
    }
    
    // Update Weight Chart
    func updateWeightChart(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        
        //here is the for loop
        for i in 0..<weightArr.count {
            
            let value = ChartDataEntry(x: Double(weightsMonthsArr[i]), y: Double(weightArr[i])) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Weight(kg)") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        heightChartView.xAxis.axisMaximum = 24
        
        heightChartView.xAxis.axisMinimum = 0
        
        weightChartView.data = data //finally - it adds the chart data to the chart and causes an update
        
        weightChartView.chartDescription?.text = "Weight Line Chart" // Here we set the description for the graph
    }
        

    //Separation Line
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        // Do any additional setup after loading the view, typically from a nib.
        //Load and Display Data from Firestore
        firestore = Firestore.firestore()
        let doc = firestore.collection(userID).document("Profile")
        doc.getDocument(completion: {(snapshot, error) in
            if let d = snapshot?.data() {
                self.UserName = d["User_name"] as! String
                self.UserChildName = d["Child_name"] as! String
                self.UserChildGender = d["Child_gender"] as! String
                self.UserChildBirthYear = d["Child_birthyear"] as! Int
                self.UserChildBirthMonth = d["Child_birthmonth"] as! Int
                self.UserChildBirthDay = d["Child_birthday"] as! Int
                self.weightArr = d["Child_weights"] as! Array<Int>
                self.heightArr = d["Child_heights"] as! Array<Int>
                self.heightsMonthsArr = d["Heights_months"] as! Array<Int>
                self.weightsMonthsArr = d["Weights_months"] as! Array<Int>
            }
            self.WhoseChild()
            self.ChildName()
            self.ChildAge(&self.UserChildAge)
            self.ChildGender()
            self.updateHeightChart()
            self.updateWeightChart()
        })
        
        // graphics
        setGradientBackground()
        childPicture.layer.borderColor = UIColor.white.cgColor
        
        let data = UserDefaults.standard.object(forKey: "savedImage") as? NSData
        if data != nil {
            displayChildPicture.image = UIImage(data: data! as Data)
        }
    }
    
    @IBAction func doBtnSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch {}
        self.dismiss(animated: false, completion: nil)
    }
    
    // from stackoverflow, generic 2 point gradient
    func setGradientBackground() {
        let colorTop =  UIColor(red: 100/255.0, green: 165/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1]
        gradientLayer.frame = self.view.bounds
        
        self.gradientLayer.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
