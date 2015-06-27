//
//  AddDailyLogViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/27/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class AddDailyLogViewController: UIViewController {

    
    @IBOutlet weak var activityType: UITextField!
    
    
    @IBOutlet weak var startTime: UITextField!
    
    
    @IBOutlet weak var endTime: UITextField!
    
    
    
    
    @IBAction func uploadLog(sender: UIButton) {
        println("uploading log ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var label = UILabel()
        // yxu: Rect: top left corner: relative to Father view's top left corder
        label.frame = CGRectMake(50, 50, 200, 200)
        label.backgroundColor = UIColor.cyanColor()
        label.text = "Hwllo World"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(16.0)
        
        view.addSubview(label)
        

        /*
        These methods might come in handy to update your view:
        
        [self.view setNeedsLayout];
        [self.view setNeedsUpdateConstraints];
        [self.view setNeedsDisplay];

        */
        
    }
    
    
}
