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
    func uploadLogItem(activityItem: DailyLogItem)
    
}


extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return  formatter.stringFromDate(self)
    }
}




class AddDailyLogViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
 
    @IBOutlet weak var activityTypeTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
 
    
    // picker views
    var activityPicker = UIPickerView()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    
    var delegate: UploadLogDelegate!
    
    
    var activityId = activityIdMin // default to minimum
    var startTime = ""
    var endTime = ""

    
    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    
    
    @IBAction func uploadLog(sender: UIButton) {
        println("uploading log ")
        
        println("activity = \(activityTypeTextField.text), id = \(activityId) \n\n")
        
        
        // todo: add sanity check:  end time > start time etc
        //   show an alert view if error detected
        
        let activityItem = DailyLogItem(uniqueId: 0, activityType: activityId, content: contentTextView.text, startTime: startTime, endTime: endTime)
        
        delegate?.uploadLogItem(activityItem)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    func startTimeChangedAction() {
        startTimeTextField.text = startTimePicker.date.formatted
        
    }
    
    func endTimeChangedAction() {
        endTimeTextField.text = endTimePicker.date.formatted
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.borderColor = UIColor.blueColor().CGColor
        contentTextView.layer.cornerRadius = 5
        
        var curTime = NSDate()
        startTime = curTime.formatted
        endTime = startTime  //todo: add logic to add 30 minutes to starttime as endtime; And check agains midnight
        
        startTimeTextField.text = startTime
        endTimeTextField.text = endTime
        
        activityPicker.dataSource = self
        activityPicker.delegate = self
        
        startTimePicker.datePickerMode = UIDatePickerMode.Time;
        startTimePicker.locale = NSLocale(localeIdentifier: "NL") //NL for Netherland, 24H; zh_Hans_CN for China
        startTimePicker.addTarget(self, action: "startTimeChangedAction", forControlEvents: UIControlEvents.ValueChanged)
  
        
        endTimePicker.datePickerMode = UIDatePickerMode.Time;
        endTimePicker.locale = NSLocale(localeIdentifier: "NL") //NL for Netherland, 24H; zh_Hans_CN for China
        endTimePicker.addTarget(self, action: "endTimeChangedAction", forControlEvents: UIControlEvents.ValueChanged)
        
        
        activityTypeTextField.text = activityTypeDictionary[activityIdMin]?.name
        
        // set up input view
        activityTypeTextField.inputView = activityPicker //show from the bottom. refer to: http://stackoverflow.com/questions/20740874/uipickerview-as-inputview-of-uitextfield

        startTimeTextField.inputView = startTimePicker
        endTimeTextField.inputView = endTimePicker
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
        