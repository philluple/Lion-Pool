//
//  TimeClass.swift
//  Lion Pool
//
//  Created by Phillip Le on 7/29/23.
//

import Foundation
import FirebaseFirestore

class TimeUtils {

    let dateFormatter = DateFormatter()
    
    let monthAbbrev: [String: String ] = [
        "January" : "Jan",
        "February" : "Feb",
        "March": "Mar",
        "April": "Apr",
        "August": "Aug",
        "September": "Sept",
        "October": "Oct",
        "November": "Nov",
        "December": "Dev"
    ]
    
    //Pass a Date() Object and convert to date string
    //Pass a Date() Object and convert to date string
    // Pass a Date() Object and convert to date string
    func formattedDate(_ date: String) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        if let newDate = dateFromISOString(date) {
            return dateFormatter.string(from: newDate)
        } else {
            return "Invalid Date"
        }
    }

    // Pass a Date() Object and convert to time string
    func formattedTime(_ date: String) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        if let newDate = dateFromISOString(date) {
            return dateFormatter.string(from: newDate)
        } else {
            return "Invalid Time"
        }
    }
    func extractDay(_ date: String) -> String {
        if let newDate = dateFromISOString(date) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: newDate)
            return String(day)
        } else {
            return "Invalid Date"
        }
    }
    
    func extractMonth(_ date: String) -> String {
        if let newDate = dateFromISOString(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let monthString = dateFormatter.string(from: newDate)
            
            if let abbreviatedMonth = monthAbbrev[monthString] {
                return abbreviatedMonth
            }
            return monthString
        } else {
            return "Invalid Date"
        }
    }
    

    func dateFromISOString(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from: dateString)
    }

    
}

