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


class RequestsViewController: UIViewController {
    
    let receivedTable = UITableView()
    let sentTable = UITableView()
    
    let dataSourceArray = ["some", "value"]
    let otherSourceArray = ["value1", "value2"]
    
    let cellId = "request"
    
    var didUpdateConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            return "Requests Received"
        } else {
            return "Requests Sent"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        if (tableView == receivedTable)
        {
            let row = indexPath.row
            cell.textLabel?.text = dataSourceArray[row]
            cell.detailTextLabel?.text = otherSourceArray[row]
        }
        else if (tableView == sentTable)
        {
            let row = indexPath.row
            cell.textLabel?.text = dataSourceArray[row]
            cell.detailTextLabel?.text = otherSourceArray[row]
            
        }
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
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