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
        
        var header = view as! UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.redColor()
        header.textLabel.font = UIFont.boldSystemFontOfSize(18)
        var headerFrame = header.frame;
        header.textLabel.frame = headerFrame;
        header.textLabel.textAlignment = NSTextAlignment.Center
    }


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // trigger segue
        if (indexPath.row == 1 && indexPath.section == 0) {
            performSegueWithIdentifier("showClassSetUp", sender: tableView)
        }
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            
            performSegueWithIdentifier("showTeacherInfo", sender: tableView)
        }
        
        
    }
    
    
    
    
    
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
