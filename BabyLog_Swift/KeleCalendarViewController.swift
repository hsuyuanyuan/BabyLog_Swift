//
//  KeleCalendarViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/26/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

//yxu: delegate to pass the date picked from calendar, back to table view
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
        println(date)
        delegate?.pickDataFromCalendar(date)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}