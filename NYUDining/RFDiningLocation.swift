//
//  RFDiningLocation.swift
//  
//
//  Created by Ross Freeman on 6/10/16.
//
//

import Foundation

enum DayOfWeek: String {
    case Sunday = "Sunday"
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Closed = "Closed"
}

class RFDiningLocation: NSObject {
    
    let name: String!
    let logoURL: String!
    let menuURL: String?
    let hours: [String]!
    let address: String!
    let coordinates: [Double]
    let data: [String: AnyObject]
    
    init(data: [String: AnyObject], params: [String: AnyObject]) {
        self.data = data
        
        let cal: String = params["calendar"] as! String
        hours = data[cal] as! [String]
        name = data["Name"] as! String
        logoURL = data["logo_URL"] as! String
        address = data["Address"] as! String
        menuURL = data["menu_url"] as? String
        coordinates = data["Coordinates"] as! [Double]
        
    }
     
    func isOpen() -> Bool {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(now))
        
        var hoursToday = ""
        
        if let dayOfWeek = dayOfWeek {
            switch dayOfWeek {
            case .Sunday:
                hoursToday = hours[0]
            case .Monday:
                hoursToday = hours[1]
            case .Tuesday:
                hoursToday = hours[2]
            case .Wednesday:
                hoursToday = hours[3]
            case .Thursday:
                hoursToday = hours[4]
            case .Friday:
                hoursToday = hours[5]
            default:
                hoursToday = hours[6]
            }
        }
        
        if hoursToday.containsString(",") {
            let timeComponents = hoursToday.componentsSeparatedByString(",")
            return isTimeInRange(timeComponents[0]) || isTimeInRange(timeComponents[1])
        }
        
        else {
            return isTimeInRange(hoursToday)
        }
    }
    
    private func normalizedTime() -> NSDate {
        let now = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        let timeStr = dateFormatter.stringFromDate(now)
        return dateFormatter.dateFromString(timeStr)!
        
    }
    
    private func isTimeInRange(timeRange: String) -> Bool {
        
        if timeRange == "Closed" {
            return false
        }
        
        let calendar = NSCalendar.currentCalendar()
        let now = normalizedTime()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        let timeComponents = timeRange.componentsSeparatedByString("-")
        
        let openTime = dateFormatter.dateFromString(timeComponents[0])
        let closeTime = dateFormatter.dateFromString(timeComponents[1])
        
        if let openTime = openTime, var closeTime = closeTime {
            
            // Check if close time is 12am
            let diffComparison = calendar.compareDate(openTime, toDate: closeTime, toUnitGranularity: .Hour)
            if diffComparison == .OrderedDescending {
                guard let newTime = calendar.dateByAddingUnit(.Day, value: 1, toDate: closeTime, options: []) else {
                    return false
                }
                closeTime = newTime
            }
            
            let openComparison = calendar.compareDate(now, toDate: openTime, toUnitGranularity: .Minute)
            let closeComparison = calendar.compareDate(now, toDate: closeTime, toUnitGranularity: .Minute)
            
            return (openComparison == .OrderedDescending && closeComparison == .OrderedAscending)
        }
        
        return false
    }
    
}