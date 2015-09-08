//
//  CreateClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/10/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class CreateClassViewController: UIViewControllerForWebAPI, UITextFieldDelegate,  UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var classAddressTextField: UITextField!

    @IBOutlet weak var className: UITextField!
    
    @IBOutlet weak var classCodeTextField: UITextField!
    
    @IBOutlet weak var classYearTextField: UITextField!
    
    @IBOutlet weak var classQuerterTextField: UITextField!
    
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    @IBOutlet weak var classSchoolTextField: UITextField!
    
    @IBOutlet weak var classDescTextView: UITextView!
    
    var classYearPIcker = UIPickerView()
    var classQuarterPicker = UIPickerView()
    
    var curYearNum = NSDate().formattedYYYY.toInt() ?? 2015
    let numYearSelection = 10
    
    
    override func viewWillAppear(animated: Bool) {
        println("view will appear: ")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        classCodeTextField.delegate = self //Note: make it not editable
        classCodeTextField.textColor = myGrayColor
        
        
        //refer to: http://stackoverflow.com/questions/1824463/how-to-style-uitextview-to-like-rounded-rect-text-field
        classDescTextView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(0.5).CGColor
        classDescTextView.layer.borderWidth = 1.0
        classDescTextView.layer.cornerRadius = 5
        classDescTextView.clipsToBounds = true
        
        classYearTextField.inputView = classYearPIcker
        classYearPIcker.dataSource = self
        classYearPIcker.delegate = self
        
        classQuerterTextField.inputView = classQuarterPicker
        classQuarterPicker.dataSource = self
        classQuarterPicker.delegate = self
        
        
        if _teacherInfo == nil {
            _getTeacherInfoAndBanjiInfo()
            
        } else {
            _getBanjiInfo()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // pickers (one for year, the other for quarter
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == classYearPIcker) {
            return numYearSelection
        }
        else if (pickerView == classQuarterPicker) {
            return 4
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == classYearPIcker) {
            return String(curYearNum + numYearSelection/2 - row)
        }
        else if (pickerView == classQuarterPicker) {
            return String(row+1)
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == classYearPIcker) {
            classYearTextField.text = String(curYearNum + numYearSelection/2 - row)
        }
        else if (pickerView == classQuarterPicker) {
            classQuerterTextField.text = String(row+1)
            
        }
        pickerView.resignFirstResponder()
    }
    
    // use to disable picker when clicking on window
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    // disable the editing in the delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    

    func _showBanjiInfoUI() {
        
        className.text = _banjiInfo?.name
        classAddressTextField.text = _banjiInfo?.addr
        classCodeTextField.text = _banjiInfo?.code
        classQuerterTextField.text = String(_banjiInfo?.quarter ?? 1)
        classYearTextField.text = _banjiInfo?.year
        classPasswordTextField.text = _banjiInfo?.password
        classSchoolTextField.text = _banjiInfo?.school
        classDescTextView.text = _banjiInfo?.desc
        
    }

    
    func _storeBanjiInfo() {
        
        _banjiInfo = BanjiInfo(name: className.text,
            addr: classAddressTextField.text,
            code: classCodeTextField.text,
            id: 0, // assigned by web api; not displayed anyway
            desc: classDescTextView.text,
            password: classPasswordTextField.text,
            quarter: classQuerterTextField.text.toInt() ?? 1,
            school: classSchoolTextField.text,
            teacherId: _teacherInfo!.id,
            teacherName: _teacherInfo!.name,
            year: classYearTextField.text)
    }
    
    
    
    @IBAction func confirmButtonTapped(sender: UIButton) {
        // call web api to create or update
        _createBanjiInfo()
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    func _createBanjiInfo() { //CreateBanji
        
        _storeBanjiInfo()
        
        _startSpinnerAndBlockUI()
        
        let urlString:String = _teacherInfo!.imageURL.absoluteString!
    
        
        var requestParams : [String:AnyObject] = [
            "Name":_banjiInfo!.name,
            "Description":_banjiInfo!.desc,
            "Address":_banjiInfo!.addr,
            "School":_banjiInfo!.school,
            "TeacherId":_banjiInfo!.teacherId,
            "BanjiId":"",
            "Province":"",
            "City":"",
            "Area":"",
            "Pic":"",
            "Password": _banjiInfo!.password,
            "YearNum": _banjiInfo!.year,
            "Quarter": _banjiInfo!.quarter
        ]
        
        
        callWebAPI(requestParams, curAPIType: APIType.CreateBanji, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForBanjiInfo(jsonResult)
                
             }
            }, postActionAfterAllReturns: { () -> () in
        
            // Make sure we are on the main thread, and update the UI.
            dispatch_async(dispatch_get_main_queue()) { //sync or async
                // update some UI
                self._showBanjiInfoUI() // similar to _showTeacherInfoUI
            
                // resume the UI at the end of async action
                self._stopSpinnerAndResumeUI()
        
            }
        })
        
    }

    
    // similar to GetTeacherInfo
    func _getBanjiInfo() {
        
        _startSpinnerAndBlockUI()
        
        var requestParams : [String:AnyObject] = [:]
        
        callWebAPI(requestParams, curAPIType: APIType.GetBanjiInfo, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                self._parseJsonForBanjiInfo(jsonResult) // similar to _parseJsonForTeacherInfo
                
            }
            }, postActionAfterAllReturns: { () -> () in
                
                // Make sure we are on the main thread, and update the UI.
                dispatch_async(dispatch_get_main_queue()) { //sync or async
                    // update some UI
                    self._showBanjiInfoUI() // similar to _showTeacherInfoUI
      
                    self._stopSpinnerAndResumeUI()
                    
                }
        })
        
    }
    
    
    //Note: have to make sure that teacher info is valid, before calling getBanji
    //      because teacher's id and name are used for create class api
    func _getTeacherInfoAndBanjiInfo() {
        
        _startSpinnerAndBlockUI()
        
        var requestParams : [String:AnyObject] = [:]
        
        callWebAPI(requestParams, curAPIType: APIType.UserGetInfo, postActionAfterSuccessulReturn: { (data) -> () in
            // refer to: https://grokswift.com/rest-with-alamofire-swiftyjson/
            if let data: AnyObject = data { //yxu: check if data is nil
                let jsonResult = JSON(data)
                
                super._parseJsonForTeacherInfo(jsonResult)
                
                self._getBanjiInfo()
                
            }
            }, postActionAfterAllReturns: { () -> () in
                
                // Make sure we are on the main thread, and update the UI.
                dispatch_async(dispatch_get_main_queue()) { //sync or async
                    // update some UI

                    println("updating the table view")
                    // resume the UI at the end of async action
                    
                    self._stopSpinnerAndResumeUI()
                    
                }
        })
        
    }
    
    
    func _parseJsonForBanjiInfo(result: JSON) {
        
        let classInfo = result["Banji"]
        
        var classaddress: String = classInfo["Address"].string ?? ""
        var classCode: String = classInfo["Code"].string ?? ""
        var classDesciption: String = classInfo["Description"].string ?? ""
        var classId: Int = classInfo["Id"].int ?? 0
        var className: String = classInfo["Name"].string ?? ""
        
        var classPassword: String = classInfo["Password"].string ?? ""
        var classQuarter: Int = classInfo["Quarter"].int ?? 1
        var classSchool: String = classInfo["School"].string ?? ""
        
        var classTeacherId: Int = classInfo["TeacherId"].int ?? 0
        var classTeacherName:String = classInfo["TeacherName"].string ?? ""
        var classYear: String = classInfo["YearNum"].string ?? "2020"
        
        if classYear == "0000" {
            let curTime = NSDate()
            classYear = curTime.formattedYYYY
        }
        
        // ignore: CreatedTime, ModifyTime, Open
        // ignore for now: Pic = "~~/Uploads/000024FilePath/d3f01f65-c15e-4176-be68-ed7a87820eb7.jpg";
        
        _banjiInfo = BanjiInfo(name: className, addr: classaddress, code: classCode, id: classId, desc: classDesciption, password: classPassword, quarter: classQuarter, school: classSchool, teacherId: classTeacherId, teacherName: classTeacherName, year: classYear)
   
    }
    
    
}
