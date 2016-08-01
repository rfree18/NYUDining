//
//  RequestsViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/20/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class RequestsViewController: UIViewController {
    
    let receivedTable = UITableView()
    let sentTable = UITableView()
    
    var sent: [[String:AnyObject]]!
    var recieved: [[String:AnyObject]]!
    
    let cellId = "request"
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         Alamofire.request(.GET, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/fbUserIdReceiver", encoding: .JSON)
            .validate()
            .responseJSON { response in
            debugPrint(response)     // prints detailed description of all response properties
         
            if let JSON = response.result.value {
                print(JSON)
                if (response.result.value is NSNull){}
                else
                { self.recieved = JSON as! [[String:AnyObject]]//[Dictionary<String,AnyObject>]}
            }
         }
        }
        view.backgroundColor = UIColor.whiteColor()
        
        receivedTable.dataSource = self
        receivedTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        sentTable.dataSource = self
        sentTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Requests"
        
        view.addSubview(receivedTable)
        view.addSubview(sentTable)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            sentTable.autoPinEdgeToSuperviewEdge(.Bottom)
            sentTable.autoPinEdgeToSuperviewEdge(.Left)
            sentTable.autoPinEdgeToSuperviewEdge(.Right)
            
            receivedTable.autoPinEdgeToSuperviewEdge(.Top)
            receivedTable.autoPinEdgeToSuperviewEdge(.Left)
            receivedTable.autoPinEdgeToSuperviewEdge(.Right)
            receivedTable.autoSetDimension(.Height, toSize: view.bounds.size.height / 2)
            receivedTable.autoPinEdge(.Bottom, toEdge: .Top, ofView: sentTable)
            
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

extension RequestsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == receivedTable {
            return "Received"
        } else {
            return "Sent"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == receivedTable {
            if (sent == nil || sent.count == 0){
                return 1
            }
            return sent.count}
        else{
            if (recieved == nil || recieved.count == 0){
                return 1
            }
            return recieved.count
        }// Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if (tableView == receivedTable)
        {
            let row = indexPath.row
            if (recieved == nil || recieved.count == 0){
                cell.textLabel?.text = "No recieved requests"
                cell.detailTextLabel?.text = "Send a request instead!"
            }
            else{
                let aPerson = recieved[row]
                cell.textLabel?.text = aPerson["fbUserName"] as! String
                cell.detailTextLabel?.text = aPerson["fbUserId"] as!String
            }
        }
        else if (tableView == sentTable)
        {
            
            let row = indexPath.row
            if (sent == nil || sent.count == 0) {
                cell.textLabel?.text = "No requests sent"
                cell.detailTextLabel?.text = "Lets find a dining hall"
            }
            else{
                let aPerson = recieved[row]
                cell.textLabel?.text = aPerson["fbUserName"] as! String
                cell.detailTextLabel?.text = aPerson["fbUserId"] as! String
            }
        }
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let locationController = RFLocationsViewController()
        if tableView == sentTable {
            let row = indexPath.row
            if (sent == nil || sent.count == 0) {
                navigationController?.pushViewController(locationController, animated: true)
            }
            else {
                let person = recieved[row]
                let pController = OtherProfileViewController()
                pController.personInfo = person
                navigationController?.pushViewController(pController, animated: true)
            }

        }
        else {
            let row = indexPath.row
            if (recieved == nil || recieved.count == 0) {
                navigationController?.pushViewController(locationController, animated: true)
            }
            else {
                //send to that persons page
                let person = recieved[row]
                let pController = OtherProfileViewController()
                pController.personInfo = person
                pController.isRequestPage = false
                navigationController?.pushViewController(pController, animated: true)
            }

        }
            }

    /*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     if (tableView == _acceptedTable)
     {
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
     cell.textLabel.text = @"Test text 1";
     cell.detailTextLabel.text = @"Test text 2";
     NSString *path = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"];
     UIImage *theImage = [UIImage imageWithContentsOfFile:path];
     cell.imageView.image = theImage;
     }
     
     if (tableView == _requestedTable)
     {
     
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
     cell.textLabel.text = @"Test text 1";
     cell.detailTextLabel.text = @"Test text 2";
     NSString *path = [[NSBundle mainBundle] pathForResource:@"TestImage" ofType:@"png"];
     UIImage *theImage = [UIImage imageWithContentsOfFile:path];
     cell.imageView.image = theImage;
     }
     return cell;
     
     }
     */
}