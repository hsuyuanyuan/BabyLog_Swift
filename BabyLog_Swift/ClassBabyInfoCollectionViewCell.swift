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
    
    @IBOutlet weak var babyImageButton: UIButton!
    
    @IBAction func babyImageButtonTapped(sender: AnyObject) {
        
    }
    
    
    
    @IBAction func arriveTimeButtonTapped(sender: AnyObject) {
        println(" arrive time button pressed")
        
        var arriveButton = sender as! UIButton
        
        //arriveButton.hidden = true
        arriveButton.removeFromSuperview()
        
        var arriveTextField = UITextField(frame: arriveButton.frame)
        arriveTextField.borderStyle  = UITextBorderStyle.RoundedRect
        
        var curTime = NSDate()
        arriveTextField.text = curTime.formattedHHMM
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
        
        var curTime = NSDate()
        leaveTextField.text = curTime.formattedHHMM
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
