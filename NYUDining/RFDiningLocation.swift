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

@objc class RFDiningLocation: NSObject {
    
    let name: String!
    let logoURL: String!
    let menuURL: String!
    let hours: [String]
    let address: String!
    let coordinates: [String]
    let data: [String: AnyObject]
    
    init(data: [String: AnyObject]) {
        self.data = data
        
        let cal: String = data["calendar"] as! String
        hours = data[cal] as! [String]
        name = data["Name"] as! String
        logoURL = data["logo_url"] as! String
        address = data["Address"] as! String
        menuURL = data["menu_url"] as! String
        coordinates = data["coordinates"] as! [String]
        
    }
    
    func isOpen() -> Bool {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = DayOfWeek(rawValue: dateFormatter.stringFromDate(date))
        
        
        dateFormatter.dateFormat = "HH:mm"
        let currentTime = dateFormatter.stringFromDate(date)
        let times = currentTime.componentsSeparatedByString(":")
        let currentHour: Double = Double(times[0])!
        let currentMinute: Double = Double(times[0])!
        let time = currentHour + currentMinute
        
        var timeA: Double
        var timeB: Double
        
        dateFormatter.dateFormat = "a"
        var hoursToday: String
        
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
            case .Saturday:
                hoursToday = hours[6]
            default:
                // TODO: Better error handling
                return false
            }
            
            if hoursToday.containsString(",") {
                let timeSlots = hoursToday.componentsSeparatedByString(",")
                
                var counter = 0
                
                for timeSlot in timeSlots {
                    counter += 1
                    
                    let times = timeSlot.componentsSeparatedByString("-")
                    
                    var time0 = times[0]
                    var time1 = times[1]
                    
                    if times[0].containsString("am") {
                        if times[0].containsString("12") {
                            timeA = 0
                        }
                        
                        else {
                            time0 = time0.stringByReplacingOccurrencesOfString("am", withString: "")
                            
                            if time0.containsString(":") {
                                let timeArray = time0.componentsSeparatedByString(":")
                                let minute = timeArray[1]
                                let minuteInHour: Double = Double(minute)! / 60
                                timeA = Double(times[0])! + minuteInHour
                            }
                            
                            else {
                                timeA = Double(times[0])!
                            }
                        }
                    }
                    
                    else {
                        time0 = time0.stringByReplacingOccurrencesOfString("pm", withString: "")
                        
                        if time0.containsString(":"){
                            let timeArray = time0.componentsSeparatedByString(":")
                            let minute = timeArray[1]
                            let minuteInHour: Double = Double(minute)! / 60
                            timeA = Double(times[0])! + minuteInHour
                        }
                        
                        else {
                            timeA = Double(times[0])!
                        }
                        
                        if timeA < 12 {
                            timeA += 12
                        }
                    }
                    
                    if times[1].containsString("am") {
                        if times[1].containsString("12") {
                            timeB = 0
                        }
                            
                        else {
                            time1 = time1.stringByReplacingOccurrencesOfString("am", withString: "")
                            
                            if time1.containsString(":") {
                                let timeArray = time0.componentsSeparatedByString(":")
                                let minute = timeArray[1]
                                let minuteInHour: Double = Double(minute)! / 60
                                timeB = Double(times[0])! + minuteInHour
                            }
                                
                            else {
                                timeB = Double(times[0])!
                            }
                        }
                        
                    }
                    
                    else {
                        time1 = time1.stringByReplacingOccurrencesOfString("pm", withString: "")
                        
                        if time1.containsString(":"){
                            let timeArray = time0.componentsSeparatedByString(":")
                            let minute = timeArray[1]
                            let minuteInHour: Double = Double(minute)! / 60
                            timeB = Double(times[1])! + minuteInHour
                        }
                            
                        else {
                            timeB = Double(times[1])!
                        }
                        
                        if timeB < 12 {
                            timeB += 12
                        }
                    }
                    
                    if time >= timeA && time < timeB {
                        return true
                    }
                    
                    else if counter == timeSlots.count {
                        return false
                    }
                    
                }
            }
            
            else {
                if hoursToday == "Closed" {
                    return false
                }
                
                else {
                    let times = hoursToday.componentsSeparatedByString("-")
                    
                    var time0 = times[0]
                    var time1 = times[1]
                    
                    if times[0].containsString("am") {
                        if times[0].containsString("12") {
                            timeA = 0
                        }
                            
                        else {
                            time0 = time0.stringByReplacingOccurrencesOfString("am", withString: "")
                            
                            if time0.containsString(":") {
                                let timeArray = time0.componentsSeparatedByString(":")
                                let minute = timeArray[1]
                                let minuteInHour: Double = Double(minute)! / 60
                                timeA = Double(times[0])! + minuteInHour
                            }
                                
                            else {
                                timeA = Double(times[0])!
                            }
                        }
                    }
                        
                    else {
                        time0 = time0.stringByReplacingOccurrencesOfString("pm", withString: "")
                        
                        if time0.containsString(":"){
                            let timeArray = time0.componentsSeparatedByString(":")
                            let minute = timeArray[1]
                            let minuteInHour: Double = Double(minute)! / 60
                            timeA = Double(times[0])! + minuteInHour
                        }
                            
                        else {
                            timeA = Double(times[0])!
                        }
                        
                        if timeA < 12 {
                            timeA += 12
                        }
                    }
                    
                    if times[1].containsString("am") {
                        if times[1].containsString("12") {
                            timeB = 0
                        }
                            
                        else {
                            time1 = time1.stringByReplacingOccurrencesOfString("am", withString: "")
                            
                            if time1.containsString(":") {
                                let timeArray = time0.componentsSeparatedByString(":")
                                let minute = timeArray[1]
                                let minuteInHour: Double = Double(minute)! / 60
                                timeB = Double(times[0])! + minuteInHour
                            }
                                
                            else {
                                timeB = Double(times[0])!
                            }
                        }
                        
                    }
                        
                    else {
                        time1 = time1.stringByReplacingOccurrencesOfString("pm", withString: "")
                        
                        if time1.containsString(":"){
                            let timeArray = time0.componentsSeparatedByString(":")
                            let minute = timeArray[1]
                            let minuteInHour: Double = Double(minute)! / 60
                            timeB = Double(times[1])! + minuteInHour
                        }
                            
                        else {
                            timeB = Double(times[1])!
                        }
                        
                        if timeB < 12 {
                            timeB += 12
                        }
                    }
                    
                    if time >= timeA && time < timeB || time >= timeA && timeB == 0 {
                        return true
                    }
                        
                    else {
                        return false
                    }
                }
            }
            
        }
        
        return false
        
    }
    
}