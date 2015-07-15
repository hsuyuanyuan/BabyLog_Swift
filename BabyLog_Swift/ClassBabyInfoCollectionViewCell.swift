//
//  ClassBabyInfoCollectionViewCell.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class ClassBabyInfoCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    var timePicker = UIDatePicker()
    var textFieldSelected: UITextField!
    
    var arriveTime: String?
    var leaveTime: String?
    
    @IBOutlet weak var babyImageButton: UIButton!
    
    @IBAction func babyImageButtonTapped(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var arriveTimeButton: UIButton? // default is !, but it is deleted to show the text field
    
    
    @IBOutlet weak var leaveTimeButton: UIButton?
    
    
    @IBAction func arriveTimeButtonTapped(sender: AnyObject) {
        println(" arrive time button pressed")
        
        var arriveButton = sender as! UIButton
        
        //arriveButton.hidden = true
        arriveButton.removeFromSuperview()
        
        var arriveTextField = UITextField(frame: arriveButton.frame)
        arriveTextField.borderStyle  = UITextBorderStyle.RoundedRect
        
        if arriveTime == nil {
            var curTime = NSDate()
            arriveTextField.text = curTime.formattedHHMM
        } else {
            arriveTextField.text = arriveTime
        }
        
        arriveTextField.delegate = self
        textFieldSelected = arriveTextField
        
        
        arriveTextField.inputView = timePicker
        addSubview(arriveTextField)
    }
    
    
    @IBAction func leaveTimeButtonTapped(sender: AnyObject) {
        println(" leave time button pressed")
 
        var leaveButton = sender as! UIButton
        
        //leaveButton.hidden = true
        leaveButton.removeFromSuperview()
        
        var leaveTextField = UITextField(frame: leaveButton.frame)
        leaveTextField.borderStyle  = UITextBorderStyle.RoundedRect
        
        if leaveTime == nil {
            var curTime = NSDate()
            leaveTextField.text = curTime.formattedHHMM
        } else {
            leaveTextField.text = leaveTime
        }
        
        leaveTextField.delegate = self
        textFieldSelected = leaveTextField
        
        leaveTextField.inputView = timePicker
        addSubview(leaveTextField)
      
    }

    
    
    // MARK: view management
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timePicker.datePickerMode = UIDatePickerMode.Time;
        timePicker.locale = NSLocale(localeIdentifier: "NL") //NL for Netherland, 24H; zh_Hans_CN for China
        timePicker.addTarget(self, action: "startTimeChangedAction:", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    
    func startTimeChangedAction(sender:UIDatePicker) {
        textFieldSelected.text = sender.date.formattedHHMM
        
    }
    
    // MARK: delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldSelected = textField
    }
    

}
