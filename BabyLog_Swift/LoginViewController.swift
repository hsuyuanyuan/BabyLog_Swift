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
   
 
    
    @IBAction func registerAccount(sender: UIButton) {
        
        if (userNameTextField.text == "") || ( passwordTextField.text == "")
        {
            displayAlert("Error in form", message: "Please enter a valid account or password")
            
        } else {
            
            // pattern:  block UI => call async => resume UI
            
            // block the UI before async action
            _startSpinnerAndBlockUI()
            
            // call login web api with async method
             var requestParams : [String:AnyObject] = ["Username": userNameTextField.text, "Password": passwordTextField.text,
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
        var requestParams : [String:AnyObject] = ["Username":userNameTextField.text, "Password":passwordTextField.text]
        
        
        callWebAPI(requestParams, curAPIType: APIType.UserLogIn, postActionAfterSuccessulReturn: { (data) -> () in
            
            let userToken = (data as! NSDictionary)["Token"] as! String
            self._saveUserToken(userToken)
            

            self.performSegueWithIdentifier("segueToShowMainTabBarVC", sender: self) //yxu: Note: segue is from the loginVC to mainVC in storyboard, not from button to mainVC, which would jump without calling performSegueWithIdentifier
            
        }, postActionAfterAllReturns: { () -> () in
            
            self._stopSpinnerAndResumeUI()
            
        }, bForLogInOrRegister: true)

      } // end of else block
        
   }

    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}


