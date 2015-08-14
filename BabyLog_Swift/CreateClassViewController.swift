//
//  CreateClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/10/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class CreateClassViewController: UIViewControllerForWebAPI {
    
    /*
    var classaddress: String = classInfo["Address"].string ?? ""
    var classCode: String = classInfo["Code"].string ?? ""
    var classDesciption: String = classInfo["Description"].string ?? ""
    var classId: Int = classInfo["Id"].int ?? 0
    var className: String = classInfo["Name"].string ?? ""
    
    var classPassword: String = classInfo["Password"].string ?? ""
    var classQuarter: Int = classInfo["Quarter"].int!
    var classSchool: String = classInfo["School"].string ?? ""
    
    var classTeacherId: Int = classInfo["TeacherId"].int ?? 0
    var classTeacherName:String = classInfo["TeacherName"].string ?? ""
    var classYear: String = classInfo["YearNum"].string ?? "2020"
    */


    
    @IBOutlet weak var classAddressTextField: UITextField!

    @IBOutlet weak var className: UITextField!
    
    @IBOutlet weak var classCodeTextField: UITextField!
    
    @IBOutlet weak var classYearTextField: UITextField!
    
    @IBOutlet weak var classQuerterTextField: UITextField!
    
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    @IBOutlet weak var classSchoolTextField: UITextField!
    
    @IBOutlet weak var classDescTextView: UITextView!
    
    
    

    /*
    ------ input
    
            public string Name { get; set; } 班级名称
            public string Description { get; set; } 描述
            public string Address { get; set; } 地址
            public string School { get; set; } 学校
            public int TeacherId { get; set; } 教师Id
            public string BanjiId { get; set; } 班级Code （不用赋值）
    
            public string Province { get; set; } 省
            public string City { get; set; } 市
            public string Area { get; set; } 区
            public string Pic { get; set; } logo iOS 中单独设置
            public string Password { get; set; } 密码
    
    
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
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func confirmButtonTapped(sender: UIButton) {
        // call web api
        
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
        
        // ignore: CreatedTime, ModifyTime, Open
        // ignore for now: Pic = "~~/Uploads/000024FilePath/d3f01f65-c15e-4176-be68-ed7a87820eb7.jpg";
        
        _banjiInfo = BanjiInfo(name: className, addr: classaddress, code: classCode, id: classId, desc: classDesciption, password: classPassword, quarter: classQuarter, school: classSchool, teacherId: classTeacherId, teacherName: classTeacherName, year: classYear)
   
    }
    
    
}
