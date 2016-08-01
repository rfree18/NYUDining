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

enum NYUSchools: Int, CustomStringConvertible {
    case CAS = 0
    case GSAS = 1
    case CD = 2
    case CGPH = 3
    case CI = 4
    case GS = 5
    case IFA = 6
    case ISAW = 7
    case SSB = 8
    case GSPS = 9
    case CN = 10
    case SPS = 11
    case SL = 12
    case SM = 13
    case SSSW = 14
    case SSCEH = 15
    case TSE = 16
    case TSA = 17
    case AD = 18
    case SH = 19
    
    static var count: Int { return NYUSchools.SH.rawValue + 1 }
    
    var description: String {
        switch self {
            
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
        default : return " "
        }
    }
}

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var schoolPicker: UIPickerView!
    
    @IBOutlet weak var year: UITextField!
    
    @IBOutlet weak var likes: UITextView!
    
    @IBOutlet weak var major: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        print("Nschools.description: \(Nschools!.description)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Nschools?.description, forKey: "possibleSchool")

    }
    
    @IBAction func saveInfo(sender: AnyObject) {
        print ("save button is pressed")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(year.text, forKey: "School_Year")
        defaults.setObject(major.text, forKey: "School_Major")
        defaults.setObject(likes.text, forKey: "Interests")
        let school = defaults.stringForKey("possibleSchool")
        defaults.setObject(school, forKey: "School")
        let fbId = defaults.stringForKey("FbUserId")
        var token = defaults.stringForKey("FCMToken")
        if (token == nil)
        {
            token = "randomvalue"
        }
        let sYear = defaults.stringForKey("School_Year")
        let sMajor = defaults.stringForKey("School_Major")
        
        let parameters1 : [String: AnyObject] = [
            "fbUserId": fbId!,
            "collegeName" : school!,
            "year" : sYear!,
            "major": sMajor!,
            "interest" : "\(likes.text)",
            "gcmId": token! ]
        
        Alamofire.request(.PUT, "http://172.17.50.254:8080/EatWithSmartService/webapi/users", parameters: parameters1, encoding: .JSON)
            .validate()
            .responseString{ response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(response.result.value)")
                print(parameters1)
        }
    }
}