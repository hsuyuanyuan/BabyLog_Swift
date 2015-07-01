//
//  AddDailyLogViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

//yxu: delegate to pass the date picked from calendar, back to table view
protocol UploadLogDelegate {
    func uploadLogItem(activityType: Int)
}

class AddDailyLogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    //@IBOutlet weak var activityType: UITextField!
    @IBOutlet weak var activityTypeTextField: UITextField!
    
    @IBOutlet weak var startTime: UITextField!
    
    @IBOutlet weak var endTime: UITextField!
    
    // picker views
    var activityPicker = UIPickerView()
    var timePicker = UIDatePicker()
    
    var delegate: UploadLogDelegate!
    
    
    var activityId = activityIdMin // default to minimum
    
    @IBAction func uploadLog(sender: UIButton) {
        println("uploading log ")
        
        
        println("activity = \(activityTypeTextField.text), id = \(activityId) \n\n")
        
        
        // todo: add sanity check:  end time > start time etc
        //   show an alert view if error detected
        
        
        
        
        /*

        class DailyLogItem: Printable {
        
        let activityType: Int
        let content: String
        let startTime: String
        let endTime: String
        let uniqueId: Int // 307-308 etc
        
        */
        
        delegate?.uploadLogItem(activityId)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityPicker.dataSource = self
        activityPicker.delegate = self
        
        timePicker.datePickerMode = UIDatePickerMode.Time;
        timePicker.locale = NSLocale(localeIdentifier: "zh_Hans_CN")
        
        activityTypeTextField.text = activityTypeDictionary[activityIdMin]?.name
        
        // set up input view
        activityTypeTextField.inputView = activityPicker //show from the bottom. refer to: http://stackoverflow.com/questions/20740874/uipickerview-as-inputview-of-uitextfield

        startTime.inputView = timePicker
        endTime.inputView = timePicker
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityTypeArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        activityId = activityTypeArray[row].id
        return activityTypeArray[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activityTypeTextField.text = activityTypeArray[row].name
        activityId = activityTypeArray[row].id
        
        activityPicker.resignFirstResponder()
    }
    
 
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var myView = UIView(frame: CGRectMake(0, 0, pickerView.bounds.width - 30, 60))
        
        var myImageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        
        myImageView.image = UIImage(named: activityTypeArray[row].imageName ?? defaultImg)
        
        let myLabel = UILabel(frame: CGRectMake(60, 0, pickerView.bounds.width - 70, 60 ))
        myLabel.font = UIFont (name: myLabel.font.fontName, size: 24)
        myLabel.text = activityTypeArray[row].name
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
 
    
}



/* //sample code
These methods might come in handy to update your view:

[self.view setNeedsLayout];
[self.view setNeedsUpdateConstraints];
[self.view setNeedsDisplay];

*/
        