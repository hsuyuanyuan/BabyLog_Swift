//
//  MoreTableViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 8/9/15.
//  Copyright (c) 2015 StreamSaga. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView() //yxu: trick to remove the empty cells in tableView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
  
    /*
    -    (void) tableView : (UITableView*) tableView
    willDisplayHeaderView : (UIView*) view
    forSection : (NSInteger) section {
    [[((UITableViewHeaderFooterView*) view) textLabel] setTextColor : [UIColor whiteColor]];
    }
    */
    // refer to: http://stackoverflow.com/questions/10232368/ios-table-view-static-cells-grouped-change-section-header-text-color
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = UIColor.redColor()
        header.textLabel!.font = UIFont.boldSystemFontOfSize(18)
        let headerFrame = header.frame;
        header.textLabel!.frame = headerFrame;
        header.textLabel!.textAlignment = NSTextAlignment.Center
    }


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //refer to below on how to fix the bug that same view was pushed twice onto navigation stack
        // http://stackoverflow.com/questions/5687991/uitableview-didselectrowatindexpath-called-twice
        
        if (self.navigationController!.topViewController != self) {
            return;
        }
        
        if (indexPath.row == 1 && indexPath.section == 0) {
            performSegueWithIdentifier("showClassSetUp", sender: tableView)
        }
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            
            performSegueWithIdentifier("showTeacherInfo", sender: tableView)
        }
        
        if (indexPath.row == 2 && indexPath.section == 0) {
            
            performSegueWithIdentifier("showDeselectBaby", sender: tableView)
        }
        
        if (indexPath.row == 0 && indexPath.section == 1) {
            
            dismissViewControllerAnimated(true, completion: nil)
        }
    
        
    }
    
  

}
