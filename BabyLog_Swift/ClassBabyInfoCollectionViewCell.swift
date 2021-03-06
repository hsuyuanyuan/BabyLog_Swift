//
//  ClassBabyInfoCollectionViewCell.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

protocol SetInAndOutTimeDelegate {
    func SetInAndOutTime(babyId: Int, time: String, inOutType: InOutType, row: Int)
    
}


class ClassBabyInfoCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    var _row = 0
    var _babyId = 0
    
    var arriveTimePicker = UIDatePicker()
    var leaveTimePicker = UIDatePicker()
    
    var arriveTime: String? { // use observer!!
    
        didSet {
            arriveTimeTextField.text = arriveTime
        }
    }
    var leaveTime: String? {
        didSet {
            leaveTimeTextField.text = leaveTime
        }
    }
    
    @IBOutlet weak var arriveTimeTextField: UITextField!
    
    @IBOutlet weak var leaveTimeTextField: UITextField!
    
    
    var delegate: SetInAndOutTimeDelegate?
    
    @IBOutlet weak var babyImageButton: UIButton!
    
    @IBAction func babyImageButtonTapped(sender: AnyObject) {
        
    }
    


    // MARK: view management
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        arriveTimePicker.datePickerMode = UIDatePickerMode.Time
        arriveTimePicker.locale = NSLocale(localeIdentifier: "NL") //NL for Netherland, 24H; zh_Hans_CN for China
        arriveTimePicker.addTarget(self, action: "finishedArriveTimePick:", forControlEvents: UIControlEvents.ValueChanged)
    
        
        leaveTimePicker.datePickerMode = UIDatePickerMode.Time
        leaveTimePicker.locale = NSLocale(localeIdentifier: "NL")
        leaveTimePicker.addTarget(self, action: "finishedLeaveTimePick:", forControlEvents: UIControlEvents.ValueChanged)
 
        
        // arrive time text field
        arriveTimeTextField.borderStyle  = UITextBorderStyle.RoundedRect
        arriveTimeTextField.layer.borderColor = myBlueColor.CGColor
        arriveTimeTextField.tag = 0
        
        arriveTimeTextField.delegate = self
        arriveTimeTextField.inputView = arriveTimePicker

        
        
        // leave time text field
        leaveTimeTextField.borderStyle  = UITextBorderStyle.RoundedRect
        leaveTimeTextField.layer.borderColor = myBlueColor.CGColor
        leaveTimeTextField.tag = _bitMaskForLeaveTime
        
        leaveTimeTextField.delegate = self
        leaveTimeTextField.inputView = leaveTimePicker

    }
    
    
    func finishedArriveTimePick(sender:UIDatePicker) {
        arriveTime = sender.date.formattedHHMM
        
    }
    
    func finishedLeaveTimePick(sender:UIDatePicker) {
        leaveTime = sender.date.formattedHHMM
        
    }

    

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.tag != _bitMaskForLeaveTime {
            
            let curTime = NSDate()

            if arriveTime == defaultStringForInTime {
                arriveTime = curTime.formattedHHMM
                textField.endEditing(true) // disable inputView just once: http://stackoverflow.com/questions/5053465/ios-uitextfield-dismissing-custom-inputview
            }
            else {
                arriveTime = curTime.formattedHHMM
            }
        }
        
        if textField.tag == _bitMaskForLeaveTime  {
            
            let curTime = NSDate()

            
            if  leaveTime == defaultStringForOutTime {
                leaveTime = curTime.formattedHHMM
                textField.endEditing(true) // disable inputView just once
            }
            else {
                leaveTime = curTime.formattedHHMM
            }
        }
        
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        // call web api to upload the In/Out time, pass time and type(1 for arrival, 2 for leaving)
        var inOutType = InOutType.Arrival
        if textField.tag == _bitMaskForLeaveTime  {
            print("This is a leave time text field ")
            inOutType = InOutType.Leaving

        }
        
        delegate?.SetInAndOutTime( _babyId, time: textField.text ?? "", inOutType: inOutType, row: _row )
        
    }
    
    
    
    
    

}
