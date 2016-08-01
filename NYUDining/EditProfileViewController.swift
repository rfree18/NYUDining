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
import PureLayout

enum NYUSchools: Int, CustomStringConvertible {
    case NA = 0
    case CAS = 1
    case GSAS = 2
    case CD = 3
    case CGPH = 4
    case CI = 5
    case GS = 6
    case IFA = 7
    case ISAW = 8
    case SSB = 9
    case GSPS = 10
    case CN = 11
    case SPS = 12
    case SL = 13
    case SM = 14
    case SSSW = 15
    case SSCEH = 16
    case TSE = 17
    case TSA = 18
    case AD = 19
    case SH = 20
    
    static var count: Int { return NYUSchools.SH.rawValue + 1 }
    
    var description: String {
        switch self {
            
        case .NA : return "Decline"
        case .CAS : return "College of Arts & Science"
        case .GSAS : return "Graduate School of Arts and Science"
        case .CD : return "College of Dentistry"
        case .CGPH : return "College of Global Public Health"
        case .CI : return "Courant Institute"
        case .GS : return "Gallatin School"
        case .IFA : return "Institute of Fine Arts"
        case .ISAW : return "Institute for the Study of the Ancient World"
        case .SSB : return "Leonard N. Stern School of Business"
        case .GSPS : return "Robert F. Wagner Graduate School of Public Service"
        case .CN : return "Rory Meyers College of Nursing"
        case .SPS : return "School of Professional Studies"
        case .SL : return "School of Law"
        case .SM : return "School of Medicine"
        case .SSSW : return "Silver School of Social Work"
        case .SSCEH : return "Steinhardt School of Culture, Education, and Human Development"
        case .TSE : return "Tandon School of Engineering"
        case .TSA : return "Tisch School of the Arts"
        case .AD : return "NYU Abu Dhabi"
        case .SH : return "NYU Shanghai"
        }
    }
}

class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private var schoolPicker = UIPickerView()
    var year = UITextField()
    var major = UITextField()
    var likes = UITextView()
    
    private let save = UIButton(type: .System)
    

    private var didUpdateConstraints = false
    
    private let viewOffset: CGFloat = 20
    private var possibleSchool: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        navigationItem.title = "Edit Profile"
        
        self.schoolPicker.dataSource = self
        self.schoolPicker.delegate = self
        save.setTitle("Save", forState: .Normal)
        save.setTitleColor(UIColor.blueColor(), forState: .Normal)
        save.addTarget(self, action: #selector(EditProfileViewController.saveInfo), forControlEvents: .TouchUpInside)
        
        
        reloadView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func updateViewConstraints() {
        if !didUpdateConstraints {
            
            schoolPicker.autoPinEdgeToSuperviewEdge(.Top)
            schoolPicker.autoPinEdgeToSuperviewEdge(.Left)
            schoolPicker.autoPinEdgeToSuperviewEdge(.Right)
            schoolPicker.autoSetDimension(.Height, toSize: view.bounds.height/3)
            year.autoPinEdgeToSuperviewMargin(.Left)
            major.autoPinEdgeToSuperviewMargin(.Left)
            likes.autoPinEdgeToSuperviewMargin(.Left)
            year.autoPinEdgeToSuperviewMargin(.Right)
            major.autoPinEdgeToSuperviewMargin(.Right)
            likes.autoPinEdgeToSuperviewMargin(.Right)
            year.autoPinEdge(.Top, toEdge: .Bottom, ofView: schoolPicker, withOffset: viewOffset)
            major.autoPinEdge(.Top, toEdge: .Bottom, ofView: year, withOffset: viewOffset)
            likes.autoPinEdge(.Top, toEdge: .Bottom, ofView: major, withOffset: viewOffset)
            likes.autoSetDimension(.Height, toSize: view.bounds.height/5)
            save.autoPinEdgeToSuperviewMargin(.Bottom)
            save.autoPinEdgeToSuperviewMargin(.Right)
            didUpdateConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    func reloadView() {
        didUpdateConstraints = false
        for view in self.view.subviews{
            view.removeFromSuperview()
        }
        
        self.schoolPicker.backgroundColor = UIColor.clearColor()
        
        //self.schoolPicker.layer.borderColor = UIColor.whiteColor().CGColor
        //self.schoolPicker.layer.borderWidth = 1
        //self.schoolPicker.showsSelectionIndicator = true
        //self.schoolPicker.
        let defaults = NSUserDefaults.standardUserDefaults()
        print(defaults.objectForKey("disc"))
        print(defaults.objectForKey("year"))
        print(defaults.objectForKey("major"))
        
        year.text = (String(defaults.integerForKey("year")))
        print(year.text)
        major.text = (defaults.objectForKey("major") as! String)
        print(major.text)
        likes.insertText(defaults.objectForKey("disc") as! String)
        print(likes.text)
        
        if !likes.hasText(){
        likes.insertText("Interests")
        }
        if !year.hasText() {
            year.placeholder = "Graduating Year"
        }
        year.font = UIFont.systemFontOfSize(15)
        year.borderStyle = UITextBorderStyle.RoundedRect
        year.autocorrectionType = UITextAutocorrectionType.No
        year.keyboardType = UIKeyboardType.Default
        year.returnKeyType = UIReturnKeyType.Done
        year.clearButtonMode = UITextFieldViewMode.WhileEditing;
        if !major.hasText() {
            major.placeholder = "Major"
        }
        major.font = UIFont.systemFontOfSize(15)
        major.borderStyle = UITextBorderStyle.RoundedRect
        major.autocorrectionType = UITextAutocorrectionType.No
        major.keyboardType = UIKeyboardType.Default
        major.returnKeyType = UIReturnKeyType.Done
        major.clearButtonMode = UITextFieldViewMode.WhileEditing;
        
        
        year.textColor = UIColor.blackColor()
        major.textColor = UIColor.blackColor()
        year.layer.borderColor = UIColor.blackColor().CGColor
        major.layer.borderColor = UIColor.blackColor().CGColor
        likes.layer.borderColor = UIColor.blackColor().CGColor
        year.layer.borderWidth = 1
        major.layer.borderWidth = 1
        likes.layer.borderWidth = 1
        
        view.addSubview(schoolPicker)
        view.addSubview(year)
        view.addSubview(major)
        view.addSubview(likes)
        view.addSubview(save)
        view.setNeedsUpdateConstraints()
    }
    
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == schoolPicker)
        {
            return 20
        }
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if (pickerView == schoolPicker)
        {
            let Nschools = NYUSchools(rawValue: (row))
            return Nschools?.description
        }
        return "nothing"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let Nschools = NYUSchools(rawValue: row)
        possibleSchool = (Nschools?.description)!

    }
    
    func saveInfo(sender: AnyObject) {
        print ("save button is pressed")
        let user = User.currentUser()
        user.description = likes.text
        user.major = major.text
        //see if this is a real issue
        user.year = Int(year.text!)
        user.school = possibleSchool
        //figure out school from picker
        var sYear:Int = 0
        if let aYear = Int(year.text!){
            sYear = aYear
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(possibleSchool, forKey: "school")
        defaults.setInteger(sYear, forKey: "year")
        defaults.setObject(major.text, forKey: "major")
        defaults.setObject(likes.text, forKey: "disc")
        var fcmToken:String = "0"
        if let afcmToken:String = defaults.objectForKey("FCMToken") as? String
        {
            fcmToken = afcmToken
        }
        
        
        let fbUserId = defaults.objectForKey("fbUserId") as! String
        let parameters1 : [String: AnyObject] = [
            
            "fbUserId": fbUserId,
            "collegeName" : possibleSchool,
            "year" : sYear,
            "major": major.text!,
            "interest" : likes.text,
            "gcmId": fcmToken ]
        
        Alamofire.request(.PUT, "http://eatwith.umxb9zewhm.us-east-1.elasticbeanstalk.com/webapi/users", parameters: parameters1, encoding: .JSON)
            .validate()
            .responseString{ response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                print(parameters1)
        }
        let lastController = ProfileViewController()
        navigationController?.pushViewController(lastController, animated: true)
    }
}