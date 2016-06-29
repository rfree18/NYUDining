//
//  FbLoginViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/28/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import Alamofire

class FbLoginViewController: UIViewController, FBSDKLoginButtonDelegate
{
    
    @IBOutlet var btnFacebook: FBSDKLoginButton!
//    @IBOutlet var btnFacebook: FBSDKLoginButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureFacebook()
 
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            
            /*self.lblName.text = "Welcome, \(strFirstName) \(strLastName)"
            self.ivUserProfileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: strPictureURL)!)!)*/
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureFacebook()
    {
        btnFacebook.readPermissions = ["public_profile", "email", "user_friends"];
        btnFacebook.delegate = self
    }
}
