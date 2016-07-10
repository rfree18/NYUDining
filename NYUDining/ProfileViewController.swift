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
import SwiftyJSON

class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let schoolLabel = UILabel()
    private let yearLabel = UILabel()
    private let majorLabel = UILabel()
    private let likesLabel = UILabel()
    private let loginButton = FBSDKLoginButton()
    
    private var picUrl: String?
    
    private var labels: [UILabel] {
        get {
            return [nameLabel, schoolLabel, yearLabel, majorLabel, likesLabel]
        }
    }
    
    private let viewOffset: CGFloat = 15
    
    private var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.title = "Profile"
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        
        reloadView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            if isUserLoggedIn() {
                imageView.autoPinEdgesToSuperviewMarginsExcludingEdge(.Bottom)
                imageView.autoSetDimension(.Height, toSize: view.bounds.size.height / 3)
                
                var previousView: UIView = imageView
                
                for labelView in labels {
                    labelView.autoPinEdgeToSuperviewEdge(.Left)
                    labelView.autoPinEdgeToSuperviewEdge(.Right)
                    labelView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: viewOffset)
                    labelView.textAlignment = .Center
                    
                    previousView = labelView
                }
            } else {
                loginButton.autoCenterInSuperview()
            }
            
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func reloadView() {
        didUpdateConstraints = false
        
        let defaults = NSUserDefaults()
        
        navigationItem.rightBarButtonItem = nil
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        if isUserLoggedIn() {
            let logout = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(ProfileViewController.logout))
            navigationItem.rightBarButtonItem = logout
            
            nameLabel.text = defaults.stringForKey("FbUserName")
            schoolLabel.text = defaults.stringForKey("School")
            yearLabel.text = defaults.stringForKey("School_Year")
            majorLabel.text = defaults.stringForKey("School_Major")
            likesLabel.text = defaults.stringForKey("Interests")
            
            if let picUrl = picUrl {
                let url = NSURL(string: picUrl)
                let data = NSData(contentsOfURL: url!)
                
                // TODO: Implement error checking
                let image = UIImage(data: data!)
                imageView.image = image
                imageView.sizeToFit()
            }
            
            view.addSubview(imageView)
            for label in labels {
                view.addSubview(label)
            }
        } else {
            view.addSubview(loginButton)
        }
        view.setNeedsUpdateConstraints()
    }
    
    func logout() {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        reloadView()
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
            if let result = result {
                let json = JSON(result)
                
                let fbUserId = json["id"].stringValue
                print("\(fbUserId)")
                let strFirstName = json["first_name"].stringValue
                let strLastName = json["last_name"].stringValue
                
                self.picUrl = json["picture"]["data"]["url"].stringValue
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("\(accessToken)", forKey: "accessToken")
                defaults.setObject(fbUserId, forKey: "FbUserId")
                defaults.setObject((strFirstName + " " + strLastName), forKey: "FbUserName")
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
            
            self.reloadView()
            
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
