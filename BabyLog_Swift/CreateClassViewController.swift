//
//  CreateClassViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/10/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class CreateClassViewController: UIViewController {
    
    
    /*
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

    */
    
    
    @IBOutlet weak var className: UITextField!
    
    
    @IBOutlet weak var classIDTextField: UITextField!
    
    
    @IBOutlet weak var classPasswordTextField: UITextField!
    
    
    @IBOutlet weak var classSchoolTextField: UITextField!
    
    
    @IBOutlet weak var classAddressTextField: UITextField!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        //dismissViewControllerAnimate
    }
    
    
    
    
}
