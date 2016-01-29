//
//  TeacherInfoViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/13/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class TeacherInfoViewController: UIViewControllerForWebAPI {
    
    
    @IBOutlet weak var teacherContainerView: UIView!
    
    @IBOutlet weak var teacherNameTextField: UITextField!
    
    
    @IBOutlet weak var teacherNickNameTextField: UITextField!
    
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    
    @IBOutlet weak var gendarTextField: UITextField!
    
    
    @IBOutlet weak var bloodTextField: UITextField!
    
    
    @IBOutlet weak var cityTextField: UITextField!
    
   
    @IBOutlet weak var provinceTextField: UITextField!
    
    
    @IBOutlet weak var countryTextField: UITextField!
    
    
    @IBOutlet weak var teacherIntroTextView: UITextView!
    
    
    var birthdayPicker = UIDatePicker()
    
    
    
    @IBAction func confirmButtonPressed(sender: AnyObject) {
        
        // call web api to update teacher info
        _updateTeacherInfo()
        
         navigationController?.popViewControllerAnimated(true)
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let scaleX:CGFloat = view.frame.width / teacherContainerView.frame.width
        
        let scaleY:CGFloat = (view.frame.height - 44 - 20 - 49) / teacherContainerView.frame.height
        
        print("view width = \(teacherContainerView.frame.width), view height = \( teacherContainerView.frame.height)" )
        print("super view width = \(view.frame.width), super view height = \( view.frame.height)" )
        
        
        /*
        http://stackoverflow.com/questions/30503254/get-frame-height-without-navigation-bar-height-and-tab-bar-height-in-deeper-view
        
        */
        
        let scale: CGFloat =   min(scaleX, scaleY)
        
        var t: CGAffineTransform = CGAffineTransformMakeScale(scale, scale)
        
        var translateX = ( teacherContainerView.frame.width ) * (scale - 1) / 2 / scale;
        if ( teacherContainerView.frame.height > view.frame.height  ) // for 4s: 320* 480, while teacherContainerView is 340 * 540
        {
            translateX += 40
        }
        
        let translateY = teacherContainerView.frame.height * (scale - 1) / 2 / scale;
        
        
        t = CGAffineTransformTranslate(t, translateX, translateY)
        
        teacherContainerView.transform = t
        
        teacherContainerView.frame = view.bounds
        
        teacherContainerView.setNeedsLayout()
        
        
        
        
        
        
        
        
        _getTeacherInfo()
        
        teacherIntroTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        teacherIntroTextView.layer.borderWidth = 1.0
        teacherIntroTextView.layer.cornerRadius = 5
        teacherIntroTextView.clipsToBounds = true
        
        
        birthdayPicker.datePickerMode = UIDatePickerMode.Date
        birthdayPicker.locale = NSLocale(localeIdentifier: "zh_Hans_CN") //NL for Netherland, 24H; zh_Hans_CN for China
        birthdayPicker.addTarget(self, action: "birthdayChangedAction", forControlEvents: UIControlEvents.ValueChanged)
        
        birthdayTextField.inputView = birthdayPicker
        
    }
    
    
    
    func birthdayChangedAction() {
        birthdayTextField.text = birthdayPicker.date.formattedYYYYMMDD_Birthday
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func _showTeacherInfoUI() {
        
        teacherNameTextField.text = _teacherInfo?.name
        teacherNickNameTextField.text = _teacherInfo?.nickName
        birthdayTextField.text = _teacherInfo?.BirthDay
        if( _teacherInfo?.sex == 0 ) {
            gendarTextField.text = "女"
        } else {
            gendarTextField.text = "男"
        }
        
        bloodTextField.text = _teacherInfo?.BloodType
        cityTextField.text = _teacherInfo?.addrCity
        provinceTextField.text = _teacherInfo?.addrProv
        countryTextField.text = _teacherInfo?.addrCountry
        if ( _teacherInfo!.intro.isEmpty) {
            teacherIntroTextView.text  = "暂 无"
        } else {
            teacherIntroTextView.text = _teacherInfo?.intro
        }
    }
    
    
    func _storeTeacherInfo() {

        let prevId = _teacherInfo!.id
        let prevImageURL = _teacherInfo!.imageURL
        let prevImageValidity = _teacherInfo!.validImageExtension
        var prevSex = 0
        if (gendarTextField.text == "男") {
            prevSex = 1
        }
        
        _teacherInfo = TeacherInfo(name: teacherNameTextField.text ?? "",
            nickName: teacherNickNameTextField.text ?? "",
            sex: prevSex,
            id: prevId,
            imageURL: prevImageURL,
            validImageExtension: prevImageValidity,
            birthDay: birthdayTextField.text ?? "",
            bloodType: bloodTextField.text ?? "",
            city: cityTextField.text ?? "",
            province: provinceTextField.text ?? "",
            country: countryTextField.text ?? "",
            intro: teacherIntroTextView.text ?? "")
    }
    
    
    // MARK: webapi
    
    func _getTeacherInfo() {
        
        _startSpinnerAndBlockUI()
        
        let requestParams : [String:AnyObject] = [:]
        
        callWebAPI(requestParams, curAPIType: APIType.UserGetInfo, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                super._parseJsonForTeacherInfo(jsonResult)
                
            }
            }, postActionAfterAllReturns: { () -> () in
                
                // Make sure we are on the main thread, and update the UI.
                dispatch_async(dispatch_get_main_queue()) { //sync or async
                    // update some UI
                    
                    self._showTeacherInfoUI() //yxu: reloadData must be called on main thread. otherwise it does not work!!!
                    
                    
                    print("updating the table view")
                    // resume the UI at the end of async action
                    
                    self._stopSpinnerAndResumeUI()
                    
                }
        })
  
    }
    
    
    func _updateTeacherInfo() {
        
        _storeTeacherInfo()
        
        _startSpinnerAndBlockUI()
        

        
        let requestParams : [String:AnyObject] = [
            "Sex":_teacherInfo!.sex,
            "BabyName":_teacherInfo!.name,
            "Nickname":_teacherInfo!.nickName,
            "Birthday":_teacherInfo!.BirthDay,
            
            // not used, empty string
            "Province":_teacherInfo!.addrProv,
            "City":_teacherInfo!.addrCity,
            "Country":_teacherInfo!.addrCountry,
            
            //
            "BloodType":_teacherInfo!.BloodType,
            "Introduction":_teacherInfo!.intro,
            
            // removed
            //"HeadImg": urlString
        ]
        
        
        callWebAPI(requestParams, curAPIType: APIType.UserUpdateInfo, postActionAfterSuccessulReturn: nil, postActionAfterAllReturns: { () -> () in
                
                // Make sure we are on the main thread, and update the UI.
                dispatch_async(dispatch_get_main_queue()) { //sync or async
                    // update some UI

                    // resume the UI at the end of async action
                    self._stopSpinnerAndResumeUI()
                }
        })
        
        
    }
    
    
    


}
