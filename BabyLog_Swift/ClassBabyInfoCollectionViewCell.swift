//
//  ClassBabyInfoCollectionViewCell.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

protocol SetInAndOutTimeDelegate {
    func SetInAndOutTime(babyId: Int, time: String, inOutType: InOutType)
    
}


class ClassBabyInfoCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    var timePicker = UIDatePicker()
    var textFieldSelected: UITextField!
    
    var arriveTime: String?
    var leaveTime: String?
    
    var delegate: SetInAndOutTimeDelegate?
    
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
        arriveTextField.tag = babyImageButton.tag // tag is the baby id, passed in when rendering the cell in the datasource method
        
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
        leaveTextField.tag = _bitMaskForLeaveTime | babyImageButton.tag // tag is the baby id, passed in when rendering the cell in the datasource method
        
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
        timePicker.addTarget(self, action: "finishedTimePick:", forControlEvents: UIControlEvents.ValueChanged)

    }
    
    
    func finishedTimePick(sender:UIDatePicker) {
        textFieldSelected.text = sender.date.formattedHHMM
        
    }
    
    // MARK: delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textFieldSelected = textField
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("text field tag: \(textFieldSelected.tag) " )
        println("\(textFieldSelected)")
        
        // call web api to upload the In/Out time, pass time and type(1 for arrival, 2 for leaving)
        var inOutType = InOutType.Arrival
        var babyId = textField.tag
        if textField.tag & _bitMaskForLeaveTime > 0 {
            println("This is a leave time text field ")
            inOutType = InOutType.Leaving
            babyId -= _bitMaskForLeaveTime
        }
        
        delegate?.SetInAndOutTime( babyId, time: textField.text, inOutType: inOutType )
        
    }
    
    
    
    
    

}
