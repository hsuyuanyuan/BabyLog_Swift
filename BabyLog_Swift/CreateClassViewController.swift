//
//  CreateClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/10/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class CreateClassViewController: UIViewControllerForWebAPI {
    
    
    @IBOutlet weak var classAddressTextField: UITextField!

    @IBOutlet weak var className: UITextField!
    
    @IBOutlet weak var classCodeTextField: UITextField!
    
    @IBOutlet weak var classYearTextField: UITextField!
    
    @IBOutlet weak var classQuerterTextField: UITextField!
    
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    @IBOutlet weak var classSchoolTextField: UITextField!
    
    @IBOutlet weak var classDescTextView: UITextView!
    

    
    override func viewWillAppear(animated: Bool) {
        println("view will appear: ")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        _getBanjiInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    

    
    /*
    ------ input
    

    
    ------ output
    
            public string Name { get; set; }
            public string Description { get; set; }
            public string Address { get; set; }
            public string School { get; set; }
            public int TeacherId { get; set; }
            public string BanjiId { get; set; }
    
            public string Province { get; set; }
            public string City { get; set; }
            public string Area { get; set; }
            public string Pic { get; set; }
            public string Password { get; set; }
    
    */
    
    
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
