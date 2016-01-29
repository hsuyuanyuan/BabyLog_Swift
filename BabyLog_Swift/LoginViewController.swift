//
//  ViewController.swift
//  BabyLog_Swift
//
//  Created by Yuan Xu on 6/20/15.
//  Copyright © 2015 StreamSaga. All rights reserved.
//

import UIKit
// import Alamofire

class LoginViewController: UIViewControllerForWebAPI {


   @IBOutlet weak var userNameTextField: UITextField!
   
   
   @IBOutlet weak var passwordTextField: UITextField!
   
 
    @IBOutlet weak var logInButton: UIButton!
    
    
    @IBOutlet weak var registerButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.backgroundColor = myBlueColor.CGColor
        registerButton.layer.backgroundColor = myOrangeColor.CGColor
    }
    
    
    @IBAction func registerAccount(sender: UIButton) {
        
        if (userNameTextField.text == "") || ( passwordTextField.text == "")
        {
            displayAlert("Error in form", message: "Please enter a valid account or password")
            
        } else {
            
            // pattern:  block UI => call async => resume UI
            
            // block the UI before async action
            _startSpinnerAndBlockUI()
            
            // call login web api with async method
             let requestParams : [String:AnyObject] = ["Username": userNameTextField.text!, "Password": passwordTextField.text!,
                "ShenFen":"2",
                "Email":"hsuyuanyuan@gmail.com"]
            
            callWebAPI(requestParams, curAPIType: APIType.UserRegistration, postActionAfterSuccessulReturn: { (data) -> () in
                
                    self._logInAccount( ) // login if registration succeeded
                
                }, postActionAfterAllReturns: { () -> () in
                    
                    self._stopSpinnerAndResumeUI()
                    
                }, bForLogInOrRegister: true)

        } // end of else block

    }
    
    
    
    
   
   @IBAction func logInAccount(sender: UIButton) {
    
        _logInAccount()
    
    }
    
    
    
    
    
    func _logInAccount() {
        
      if (userNameTextField.text == "") || ( passwordTextField.text == "")
      {
         displayAlert("Error in form", message: "Please enter a valid account or password")

      } else {
      
        // pattern:  block UI => call async => resume UI
        
        // block the UI before async action
        _startSpinnerAndBlockUI()
        
        // call login web api with async method
        let requestParams : [String:AnyObject] = ["Username":userNameTextField.text!, "Password":passwordTextField.text!]
        
        
        callWebAPI(requestParams, curAPIType: APIType.UserLogIn, postActionAfterSuccessulReturn: { (data) -> () in
            
            let userToken = (data as! NSDictionary)["Token"] as! String
            let rongyunToken = (data as! NSDictionary)["RYToken"] as! String
            self._saveUserTokenAndRongyunToken(userToken, rongyunToken: rongyunToken)
            
            
            // Rongyun registration
            RCIM.sharedRCIM().initWithAppKey("pvxdm17jxr4rr")
            RCIM.sharedRCIM().connectWithToken(rongyunToken, success: { (userid: String!) -> Void in
                print("Rongyun connected ")
                }, error: { (error: RCConnectErrorCode) -> Void in
                    print("connection to Rongyun failed")
                }) { () -> Void in
                    print("Rongyun token wrong!")
            }

            self.performSegueWithIdentifier("segueToShowMainTabBarVC", sender: self) //yxu: Note: segue is from the loginVC to mainVC in storyboard, not from button to mainVC, which would jump without calling performSegueWithIdentifier
            
        }, postActionAfterAllReturns: { () -> () in
            
            self._stopSpinnerAndResumeUI()
            
        }, bForLogInOrRegister: true)

      } // end of else block
        
   }

    
    // http://stackoverflow.com/questions/30892254/override-func-error-in-swift-2
    // original Obj-C prototype has been changed
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


