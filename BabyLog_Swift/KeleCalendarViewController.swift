//
//  KeleCalendarViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/26/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

protocol PickDateDelegate {
    func pickDataFromCalendar(date: String)
}

class KeleCalendarViewController: UIViewController, KeleCalDelegate {

    var delegate: PickDateDelegate!
    
    
    var kele: KeleCalMainView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kele = KeleCalMainView()
        kele.delegate = self
        kele.render()
        
        view.addSubview(kele)
        
    }
    
    
    // MARK: delegate for KeleCalDelegate
    func onCellRender(cell: KeleCalCellView, kdate: CalDateTimeVO) {
        //println("keleMain.onCellRender:\(kdate.year!)-\(kdate.month!)-\(kdate.day!)")
    }
    

    func onCellPressed(cell: KeleCalCellView, kdate: CalDateTimeVO) {
        let date = "\(kdate.year!)-\(kdate.month!)-\(kdate.day!)"
        print(date)
        delegate?.pickDataFromCalendar(date)
        
        dismissViewControllerAnimated(true, completion: nil)        
    }
    
}
