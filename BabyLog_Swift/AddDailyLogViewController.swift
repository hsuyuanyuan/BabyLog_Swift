//
//  AddDailyLogViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit


protocol UploadLogDelegate {
    func uploadLogItem(activityItem: DailyLogItem)
    
}



class AddDailyLogViewController: UIViewControllerForWebAPI, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var dailyLogContainerView: UIView!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
 
    @IBOutlet weak var activityTypeTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
 
    var _imageList = [UIImage]()
    
    // delegate
    var delegate: UploadLogDelegate!
    
    // picker views
    var activityPicker = UIPickerView()
    var startTimePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()

    var activityId = activityIdMin // default to minimum
    var startTime = ""
    var endTime = ""

    @IBAction func cancelAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func uploadLog(sender: UIButton) {
        println("uploading log ")
        
        println("activity = \(activityTypeTextField.text), id = \(activityId) \n\n")
        
        // TODO: add sanity check:  end time > start time etc
        //   show an alert view if error detected
        
        let activityItem = DailyLogItem(uniqueId: 0, activityType: activityId, content: contentTextView.text, startTime: startTime, endTime: endTime)
        
        delegate?.uploadLogItem(activityItem)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

    func startTimeChangedAction() {
        startTimeTextField.text = startTimePicker.date.formattedHHMM
        
    }
    
    func endTimeChangedAction() {
        endTimeTextField.text = endTimePicker.date.formattedHHMM
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if( dailyLogContainerView != nil) {
            
            println("view width = \(dailyLogContainerView.frame.width), view height = \( dailyLogContainerView.frame.height)" )
            println("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
            
            
            var scaleX:CGFloat = view.frame.width / dailyLogContainerView.frame.width
            
            var scaleY:CGFloat = (view.frame.height - 44 - 20 - 49) / dailyLogContainerView.frame.height
            
            println("view width = \(dailyLogContainerView.frame.width), view height = \( dailyLogContainerView.frame.height)" )
            println("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
            
            
            /*
            http://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view
            
            */
            
            var scale: CGFloat =   min(scaleX, scaleY)
            
            var t: CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
            
            var translateX = ( dailyLogContainerView.frame.width ) * (scale - 1) / 2 / scale;
            if ( dailyLogContainerView.frame.height > view.frame.height  ) // for 4s: 320* 480, while teacherContainerView is 340 * 540
            {
                translateX += 40
            }
            
            var translateY = dailyLogContainerView.frame.height * (scale - 1) / 2 / scale;
            
            
            t = CGAffineTransformTranslate(t, translateX, translateY)
            
            dailyLogContainerView.transform = t
            
            dailyLogContainerView.frame = view.bounds
            
            dailyLogContainerView.setNeedsLayout()
        
        }
        
        
        
        
        
        
        
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.borderColor = myGrayColor.CGColor
        contentTextView.layer.cornerRadius = 5
        
        var curTime = NSDate()
        startTime = curTime.formattedHHMM
        endTime = startTime  // TODO add logic to add 30 minutes to starttime as endtime; And check agains midnight; make them aligned on 5 minutes resolution
        
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
        
        
        //contentTextView      
        contentTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        contentTextView.layer.borderWidth = 1.0
        contentTextView.layer.cornerRadius = 5
        contentTextView.clipsToBounds = true
        
    }
    
    
    
    // MARK: delegate for customized UIPicker for activity types
    
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
        
        var myView = UIView(frame: CGRectMake(0, 0, pickerView.bounds.width - 30, 40))
        
        var myImageView = UIImageView(frame: CGRectMake(0, 4, 32, 32))
        
        myImageView.image = UIImage(named: activityTypeArray[row].imageName ?? defaultImg)
        
        let myLabel = UILabel(frame: CGRectMake(60, 0, pickerView.bounds.width - 70, 40 ))
        myLabel.font = UIFont (name: myLabel.font.fontName, size: 24)
        myLabel.text = activityTypeArray[row].name
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    

 
}


        