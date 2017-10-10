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

class DiningLocation: NSObject {
    
    let name: String!
    let logoURL: String!
    let menuURL: String?
    let hours: [String]!
    let address: String!
    let coordinates: [Double]!
    let data: [String: AnyObject]
    
    init?(data: [String: AnyObject], params: [String: AnyObject]) {
        self.data = data
        
        guard let cal = params["calendar"] as? String,
            let hours = data[cal] as? [String],
            let name = data["Name"] as? String,
            let logoURL = data["logo_URL"] as? String,
            let address = data["Address"] as? String,
            let coordinates = data["Coordinates"] as? [Double] else {
                return nil
        }
        
        self.hours = hours
        self.name = name
        self.logoURL = logoURL
        self.address = address
        self.menuURL = data["menu_url"] as? String
        self.coordinates = coordinates
        
    }
     
    func isOpen() -> Bool {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = DayOfWeek(rawValue: dateFormatter.string(from: now))
        
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
        
        if hoursToday.contains(",") {
            let timeComponents = hoursToday.components(separatedBy: ",")
            return isTimeInRange(timeComponents[0]) || isTimeInRange(timeComponents[1])
        }
        
        else {
            return isTimeInRange(hoursToday)
        }
    }
    
    fileprivate func normalizedTime() -> Date {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        let timeStr = dateFormatter.string(from: now)
        return dateFormatter.date(from: timeStr)!
        
    }
    
    fileprivate func isTimeInRange(_ timeRange: String) -> Bool {
        
        if timeRange == "Closed" {
            return false
        }
        
        let calendar = Calendar.current
        let now = normalizedTime()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        let timeComponents = timeRange.components(separatedBy: "-")
        
        let openTime = dateFormatter.date(from: timeComponents[0])
        let closeTime = dateFormatter.date(from: timeComponents[1])
        
        if let openTime = openTime, var closeTime = closeTime {
            
            // Check if close time is 12am
            let diffComparison = (calendar as NSCalendar).compare(openTime, to: closeTime, toUnitGranularity: .hour)
            if diffComparison == .orderedDescending {
                guard let newTime = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: closeTime, options: []) else {
                    return false
                }
                closeTime = newTime
            }
            
            let openComparison = (calendar as NSCalendar).compare(now, to: openTime, toUnitGranularity: .minute)
            let closeComparison = (calendar as NSCalendar).compare(now, to: closeTime, toUnitGranularity: .minute)
            
            return (openComparison == .orderedDescending && closeComparison == .orderedAscending)
        }
        
        return false
    }
    
}
