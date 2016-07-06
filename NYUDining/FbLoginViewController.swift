
//
//  FbLoginViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/29/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import Alamofire

class FbLoginViewController: UIViewController, FBSDKLoginButtonDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //configureFacebook()
        /*if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            let loginManager: FBSDKLoginManager = FBSDKLoginManager()
            loginManager.logOut()
            FBSDKAccessToken.// User is already logged in, do work such as go to next view controller.
        }
        else
        {*/
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        //}
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if (result != nil)
            {
                let fbUserId: String = (result.objectForKey("id") as? String)!
                print("\(fbUserId)")
                let strFirstName: String = (result.objectForKey("first_name") as? String)!
                let strLastName: String = (result.objectForKey("last_name") as? String)!
                let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("\(accessToken)", forKey: "accessToken")
                defaults.setObject(fbUserId, forKey: "FbUserId")
                defaults.setObject((strFirstName + " " + strLastName), forKey: "FbUserName")
                defaults.setObject(strPictureURL, forKey: "FbUserPicture")
                let parameters : [String : AnyObject] = [
                    "fbUserId": fbUserId,
                    "fbUserName" : (strFirstName + " " + strLastName),
                    "accessToken" : "\(accessToken)"]
                
                Alamofire.request(.POST, "http://172.17.50.254:8080/EatWithSmartService/webapi/users", parameters: parameters, encoding: .JSON)
                    .validate()
                    .responseString { response in
                        print("Success: \(response.result.isSuccess)")
                        print("Response String: \(response.result.value)")
                        print(parameters)
                }

            }
            
            /*self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
             self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)*/
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        print("logged out")
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
