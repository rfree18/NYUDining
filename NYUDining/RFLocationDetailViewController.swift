//
//  RFLocationDetailViewController.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD

class RFLocationDetailViewController: UIViewController {
    
    var location: RFDiningLocation!
    
    @IBOutlet weak var locationLogo: UIImageView!
    @IBOutlet weak var locationStatusLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = location.name
        
        MBProgressHUD.showHUDAddedTo(self.navigationController?.view, animated: true)
        
        dispatch_async(dispatch_get_main_queue()) {
            let url = NSURL(string: self.location.logoURL!)
            let data = NSData(contentsOfURL: url!)
            
            // TODO: Implement error checking
            if let data = data {
                self.locationLogo.image = UIImage(data: data)
            }
            
            MBProgressHUD.hideHUDForView(self.navigationController?.view, animated: true)
            
        }
        
        hoursLabel.preferredMaxLayoutWidth = 200
        hoursLabel.text = getHoursString()
        
        if location.menuURL == nil {
            menuButton.hidden = true
        }
        
        if location.isOpen() {
            locationStatusLabel.text = "Open"
            locationStatusLabel.textColor = UIColor(red: 0.133, green: 0.580, blue: 0.282, alpha: 1.0)
        }
        
        else {
            locationStatusLabel.text = "Closed"
            locationStatusLabel.textColor = UIColor.redColor()
        }
        
        let x = location.coordinates[0]
        let y = location.coordinates[1]
        
        let camera = GMSCameraPosition.cameraWithLatitude(x, longitude: y, zoom: 16)
        
        mapView.frame = CGRectZero
        mapView.camera = camera
        
        let marker = GMSMarker(position: CLLocationCoordinate2DMake(x, y))
        marker.title = location.name!
        marker.snippet = location.address!
        marker.map = mapView
        
        mapView.selectedMarker = marker
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHoursString() -> String {
        var hoursString = ""
        var hoursToday = ""
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(NSDate()))
        
        if let dayOfWeek = dayOfWeek {
            switch dayOfWeek {
            case .Sunday:
                hoursToday = location.hours[0]
            case .Monday:
                hoursToday = location.hours[1]
            case .Tuesday:
                hoursToday = location.hours[2]
            case .Wednesday:
                hoursToday = location.hours[3]
            case .Thursday:
                hoursToday = location.hours[4]
            case .Friday:
                hoursToday = location.hours[5]
            default:
                hoursToday = location.hours[6]
            }
            hoursString = hoursToday.stringByReplacingOccurrencesOfString(",", withString: "\n")
        }
        
            
        return hoursString
        
    }
    
    // MARK: Navigation
    
    @IBAction func goToHoursTable(sender: AnyObject) {
        let tableVc = RFHoursTableViewController()
        tableVc.diningLocation = location
        
        navigationController?.pushViewController(tableVc, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMenu" {
            let dest = segue.destinationViewController as! RFMenuBrowserViewController
            dest.location = location
        }
    }
    
}
