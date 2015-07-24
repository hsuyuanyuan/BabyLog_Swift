//
//  MainTabBarController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/24/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tabBar.tintColor = UIColor.greenColor()
        tabBar.barTintColor = UIColor(
            red: 229 / 255.0,
            green: 229 / 255.0,
            blue: 229 / 255.0,
            alpha: CGFloat(1.0)
        ) // refer to: http://stackoverflow.com/questions/24074257/how-to-use-uicolorfromrgb-value-in-swift
 
    }
    
    
}
