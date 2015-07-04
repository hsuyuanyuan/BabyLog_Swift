//
//  ClassBabyInfoCollectionViewCell.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 7/3/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class ClassBabyInfoCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var babyImageView: UIImageView!
    
    
    @IBAction func arriveTimeButtonTapped(sender: AnyObject) {
        println(" arrive time button pressed")
        
    }
    
    
    @IBAction func leaveTimeButtonTapped(sender: AnyObject) {
        println(" leave time button pressed")
        
        
    }

    
    
}
