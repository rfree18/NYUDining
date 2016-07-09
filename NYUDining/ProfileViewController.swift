//
//  ProfileViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/20/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import PureLayout
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let schoolLabel = UILabel()
    private let yearLabel = UILabel()
    private let majorLabel = UILabel()
    private let likesLabel = UILabel()
    private let loginButton = FBSDKLoginButton()
    
    private var labels: [UILabel] {
        get {
            return [nameLabel, schoolLabel, yearLabel, majorLabel, likesLabel]
        }
    }
    
    private let viewOffset: CGFloat = 15
    
    private var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = NSUserDefaults()
        
        nameLabel.text = defaults.stringForKey("FbUserName")
        schoolLabel.text = defaults.stringForKey("School")
        yearLabel.text = defaults.stringForKey("School_Year")
        majorLabel.text = defaults.stringForKey("School_Major")
        likesLabel.text = defaults.stringForKey("Interests")
        
        if isUserLoggedIn() {
            loginButton.removeFromSuperview()
            for label in labels {
                view.addSubview(label)
            }
        } else {
            view.addSubview(loginButton)
        }
        
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            if isUserLoggedIn() {
                imageView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
                imageView.autoSetDimension(.Height, toSize: view.bounds.size.height / 3)
                
                var previousView: UIView = imageView
                
                for labelView in labels {
                    labelView.autoAlignAxisToSuperviewAxis(.Horizontal)
                    labelView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: viewOffset)
                    
                    previousView = labelView
                }
            } else {
                loginButton.autoCenterInSuperview()
            }
            
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: Helper Methods
    
    private func isUserLoggedIn() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
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
}
