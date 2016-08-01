//
//  OtherProfileViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 7/30/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import PureLayout
import FBSDKCoreKit
import SwiftyJSON

class OtherProfileViewController: UIViewController {
    
    var personInfo: [String: AnyObject]!
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let schoolLabel = UILabel()
    private let yearLabel = UILabel()
    private let majorLabel = UILabel()
    private let likesLabel = UILabel()
    var isRequestPage:Bool!
    var location:String!
    private let requestButton = UIButton(type: .System)
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
        
        navigationItem.title = "User Profile"
        //requestButton.frame = CGRectMake(100, 100, 100, 50)
        requestButton.backgroundColor = UIColor.clearColor()
        if (isRequestPage != nil && isRequestPage == true){
            requestButton.setImage(UIImage(named: "Request_button"), forState: .Normal)
        }
        else if (isRequestPage != nil && isRequestPage == false){
            requestButton.setImage(UIImage(named: "acceptButton"), forState: .Normal)
        }
        requestButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        requestButton.addTarget(self, action: #selector(OtherProfileViewController.requesting), forControlEvents: .TouchUpInside)
        requestButton.layer.cornerRadius = 5
        reloadView()
    }
    
    func requesting(sender:UIButton){
        if (isRequestPage != nil && isRequestPage) {
            if !isUserLoggedIn() {
                let pController = ProfileViewController()
                navigationController?.pushViewController(pController, animated: true)
            }
            else {
                
                 let reqTime = NSDate()
                 let dateFormatter = NSDateFormatter()
                 
                 dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                 
                 let convertedDate = dateFormatter.stringFromDate(reqTime)
                 print(convertedDate)
                 
                 let defaults = NSUserDefaults()
                 let FbId = defaults.stringForKey("fbUserId")
                 
                
                 let newString = location.stringByReplacingOccurrencesOfString(" ", withString: "")
                 print (newString)
                 let parameters2: [String : AnyObject] = [
                 "fbUserIdSender": FbId!,
                 "fbUserIdReceiver": personInfo["fbUserId"]!,
                 "requestDateTime":"\(convertedDate)",
                 "diningHallName": newString]
                Alamofire.request(.POST, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/friendRequest", parameters: parameters2, encoding: .JSON)
                    .validate()
                    .responseString{ response in
                        print("Success: \(response.result.isSuccess)")
                        print("Response String: \(response.result.value)")
                }
/*
                // POST SEND ALOMOFIRE REQUEST (http://172.17.50.254:8080/EatWithSmartService/webapi/friendRequest)
                {
                    
                    "fbUserIdSender":2000,
                    
                    "fbUserIdReceiver":5000,
                    
                    "requestDateTime":"2012-07-06 10:00:00",
                    
                    "requestStatus":"pending",
                    
                    "diningHallName":"dhn1"
                }
*/
            }
        }
        else{
            let reqTime = NSDate()
            let dateFormatter = NSDateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let convertedDate = dateFormatter.stringFromDate(reqTime)
            print(convertedDate)
            
            let defaults = NSUserDefaults()
            let FbId = defaults.stringForKey("fbUserId")
            
            
            let newString = location.stringByReplacingOccurrencesOfString(" ", withString: "")
            print (newString)
            let parameters2: [String : AnyObject] = [
                "fbUserIdSender": FbId!,
                "fbUserIdReceiver": personInfo["fbUserId"]!,
                "requestDateTime":"\(convertedDate)",
                "requestStatus":"accept",
                "diningHallName": newString]
            Alamofire.request(.POST, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/friendRequest", parameters: parameters2, encoding: .JSON)
                .validate()
                .responseString{ response in
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result.value)")
            }

           /* //Send Alomofire Accept
            friend request update(accept/decline)
            PUT (http://172.17.50.254:8080/EatWithSmartService/webapi/friendRequest)
                {
                    
                    "fbUserIdSender":2000,
                    
                    "fbUserIdReceiver":5000,
                    
                    "requestDateTime":"2012-07-06 10:00:00",
                    
                    "requestStatus":"accept",
                    
                    "diningHallName":"dhn1"
            }
*/
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            imageView.autoPinEdgeToSuperviewEdge(.Top)
            //imageView.autoPinEdgeToSuperviewEdge(.Left, withInset: 50)
            imageView.autoSetDimension(.Width, toSize: view.bounds.size.height / 3)
            imageView.autoSetDimension(.Height, toSize: view.bounds.size.height / 3)
            imageView.autoAlignAxisToSuperviewAxis(.Vertical)
            requestButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView, withOffset: viewOffset)
            requestButton.autoPinEdgeToSuperviewEdge(.Left)
            requestButton.autoPinEdgeToSuperviewEdge(.Right)
                
            var previousView: UIView = requestButton
                
            for labelView in labels {
                labelView.autoPinEdgeToSuperviewEdge(.Left)
                labelView.autoPinEdgeToSuperviewEdge(.Right)
                labelView.autoPinEdge(.Top, toEdge: .Bottom, ofView: previousView, withOffset: viewOffset)
                labelView.textAlignment = .Center
                    
                previousView = labelView
            }
            
            didUpdateConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    func reloadView() {
        didUpdateConstraints = false
        
        navigationItem.rightBarButtonItem = nil
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
            
            
            
        let user = User.currentUser()
        var sfName = "first"
        var slName = "last"
            
        if let firstName = defaults.objectForKey("firstName")  {
                sfName = firstName as! String}
        if let lastName = defaults.objectForKey("lastName")  {
                slName = lastName as! String}
            
        print (" current values")
        print (sfName)
        print (slName)
        nameLabel.text = (sfName + " " + slName)
        print(nameLabel.text)
        schoolLabel.text = user.school
        yearLabel.text = String(user.year)
        majorLabel.text = user.getMajor()
        likesLabel.text = user.getDescription()
            
        if let picUrl = defaults.objectForKey("photoUrl") {
        let url = NSURL(string: picUrl as! String)
        let data = NSData(contentsOfURL: url!)
                
                // TODO: Implement error checking
        let image = UIImage(data: data!)
        imageView.image = image
        imageView.sizeToFit()
            }
            
        view.addSubview(imageView)
        view.addSubview(requestButton)
        for label in labels {
            view.addSubview(label)
            }
        view.setNeedsUpdateConstraints()
    }
    
    private func isUserLoggedIn() -> Bool {
        
        //remove later
        print("printing access token")
        if FBSDKAccessToken.currentAccessToken() != nil{
            print(FBSDKAccessToken.currentAccessToken())
        }
        return FBSDKAccessToken.currentAccessToken() != nil
    }

}
