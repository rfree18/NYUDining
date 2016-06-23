//
//  EditProfileViewController.swift
//  NYUDining
//
//  Created by Jesus Leal on 6/20/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var schoolPicker: UIPickerView!
    
    @IBOutlet weak var year: UITextField!
    
    @IBOutlet weak var likes: UITextView!
    
    @IBOutlet weak var major: UITextField!
    
    var schoolDataSource : Array = ["College of Arts & Science", "Graduate School of Arts and Science", "College of Dentistry", "College of Global Public Health", "Courant Institute", "Gallatin School", "Institute of Fine Arts", "Institute for the Study of the Ancient World", "Leonard N. Stern School of Business", "Robert F. Wagner Graduate School of Public Service", "Rory Meyers College of Nursing", "School of Professional Studies", "School of Law", "School of Medicine", "Silver School of Social Work", "Steinhardt School of Culture, Education, and Human Development", " Tandon School of Engineering", "Tisch School of the Arts", "NYU Abu Dhabi", "NYU Shanghai"];

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == schoolPicker)
        {
            return schoolDataSource.count
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == schoolPicker)
        {
            return schoolDataSource[row]
        }
        return "nothing"
    }
    
    @IBAction func saveInfo(sender: AnyObject) {
        let parameters1 : [String: AnyObject] = [
            "fbUserId": 5000,
            "year" : "\(year.text)",
            "major": "cse",
            "interest" : "a,b,c",
            "gcmId": "gcm1" ]
        
        Alamofire.request(.PUT, "http://172.17.54.82:8080/EatWithSmartService/webapi/users", parameters: parameters1, encoding: .JSON)
            .validate()
            .responseString{ response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
        }

    }
    
}