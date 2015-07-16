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
    
    var timePicker = UIDatePicker()
    var textFieldSelected: UITextField!
    
    var arriveTime: String? { // use observer!!
    
        didSet {
            arriveTextField.text = arriveTime
        }
    }
    var leaveTime: String? {
        didSet {
            leaveTextField.text = leaveTime
        }
    }
    
    var arriveTextField = UITextField() // dummy for now, created when button is clicked
    var leaveTextField = UITextField() // dummy for now, created when button is clicked
    
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
        
        arriveTextField = UITextField(frame: arriveButton.frame)
        arriveTextField.borderStyle  = UITextBorderStyle.RoundedRect
        arriveTextField.tag = 0
        
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
        
        leaveTextField = UITextField(frame: leaveButton.frame)
        leaveTextField.borderStyle  = UITextBorderStyle.RoundedRect
        leaveTextField.tag = _bitMaskForLeaveTime
        
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
        if textField.tag == _bitMaskForLeaveTime  {
            println("This is a leave time text field ")
            inOutType = InOutType.Leaving

        }
        
        delegate?.SetInAndOutTime( _babyId, time: textField.text, inOutType: inOutType, row: _row )
        
    }
    
    
    
    
    

}
