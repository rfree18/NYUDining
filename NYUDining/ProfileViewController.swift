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
    private let editButton = UIButton(type: .System)
    private var needsEdit = false
    let backView = UIView()

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
        editButton.frame = CGRectMake(100, 100, 100, 50)
        editButton.backgroundColor = UIColor.clearColor()
        editButton.setTitle("edit", forState: .Normal)
        editButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        editButton.addTarget(self, action: #selector(ProfileViewController.editPressed), forControlEvents: .TouchUpInside)
        editButton.layer.cornerRadius = 5
        reloadView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    func editPressed(sender:UIButton){
        let editController = EditProfileViewController()
        //editController.year.insertText(yearLabel.text!)
        //editController.major.insertText(majorLabel.text!)
        //editController.likes.insertText(likesLabel.text!)
        navigationController?.pushViewController(editController, animated: true)
    }
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            if isUserLoggedIn() {
                backView.hidden = false
                backView.autoPinEdgeToSuperviewEdge(.Top)
                backView.autoPinEdgeToSuperviewEdge(.Left)
                backView.autoPinEdgeToSuperviewEdge(.Right)
                imageView.autoPinEdgeToSuperviewEdge(.Top)
                //imageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 50)
                imageView.autoSetDimension(.Width, toSize: view.bounds.size.height / 3)
                imageView.autoSetDimension(.Height, toSize: view.bounds.size.height / 3)
                imageView.autoAlignAxisToSuperviewAxis(.Vertical)
                editButton.autoPinEdgeToSuperviewMargin(.Bottom)
                editButton.autoPinEdgeToSuperviewMargin(.Right)
                
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
        if (needsEdit)
        {
            pushToEdit()
        }
        didUpdateConstraints = false
        
        navigationItem.rightBarButtonItem = nil
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        print (isUserLoggedIn())
        if isUserLoggedIn() {
            let logout = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: #selector(ProfileViewController.logout))
            navigationItem.rightBarButtonItem = logout
            let defaults = NSUserDefaults.standardUserDefaults()
            
            
            
            let user = User.currentUser()
            var sfName = "first"
            var slName = "last"
            var sSchool = "No school posted"
            var sYear = "No year posted"
            var sMajor = "No major posted"
            var sDisc = "No description given"
            
            if let firstName = defaults.objectForKey("firstName")  {
                sfName = firstName as! String}
            if let lastName = defaults.objectForKey("lastName")  {
                slName = lastName as! String}
            if let school = defaults.objectForKey("school"){
                sSchool = school as! String
            }
            print (defaults.objectForKey("school"))
            if let year:Int = defaults.integerForKey("year"){
                sYear = String(year)
            }
            print (defaults.objectForKey("year"))

            if let major = defaults.objectForKey("major"){
                sMajor = major as! String
            }
            print (defaults.objectForKey("major"))

            if let disc = defaults.objectForKey("disc"){
                sDisc = disc as! String
            }
            print (defaults.objectForKey("disc"))

            print (" current values")
            print (sfName)
            print (slName)
            nameLabel.text = (sfName + " " + slName)
            print(nameLabel.text)
            schoolLabel.text = sSchool
            yearLabel.text = sYear
            majorLabel.text = sMajor
            likesLabel.text = sDisc
            
            if let picUrl = defaults.objectForKey("photoUrl") {
                let url = NSURL(string: picUrl as! String)
                let data = NSData(contentsOfURL: url!)
                
                // TODO: Implement error checking
                let image = UIImage(data: data!)
                imageView.image = image
                imageView.sizeToFit()
            }
            backView.backgroundColor = UIColor.tabColor()
            view.addSubview(backView)
            view.addSubview(imageView)
            view.addSubview(editButton)
            for label in labels {
                view.addSubview(label)
            }
        } else {
            view.addSubview(loginButton)
        }
        view.setNeedsUpdateConstraints()
    }
    
    func logout() {
        User.logOut()
        
        reloadView()
    }
    
    // MARK: Helper Methods
    
    private func isUserLoggedIn() -> Bool {
        
        //remove later
        print("printing access token")
        if FBSDKAccessToken.currentAccessToken() != nil{
        print(FBSDKAccessToken.currentAccessToken())
        }
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            if let result = result {
                let json = JSON(result)
                let user = User.currentUser()
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(json["id"].stringValue, forKey: "fbUserId")
                defaults.setObject(json["first_name"].stringValue, forKey: "firstName")
                defaults.setObject(json["last_name"].stringValue, forKey: "lastName")
                
                
                user.fbUserId = json["id"].stringValue
                user.firstName = json["first_name"].stringValue
                user.lastName = json["last_name"].stringValue
                print("first time getting values from fbsdk")
                defaults.setObject(json["picture"]["data"]["url"].stringValue, forKey: "photoUrl")
                user.photoUrl = json["picture"]["data"]["url"].stringValue
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                let parameters : [String : AnyObject] = [
                    "fbUserId": user.fbUserId ?? "",
                    "fbUserName" : (user.getFirstName() + " " + user.getLastName()),
                    "accessToken" : "\(accessToken)"]
                
                Alamofire.request(.POST, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/users", parameters: parameters, encoding: .JSON)
                    .validate()
                    .responseString { response in
                        print("Success: \(response.result.isSuccess)")
                        print("Response String: \(response.result.value)")
                        print(parameters)
                }
                
            }
            self.needsEdit = true
            self.reloadView()
            
        }
    }
    func pushToEdit(){
        let editController = EditProfileViewController()
        navigationController?.pushViewController(editController, animated: true)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        print("logged out")
        
    }
}
