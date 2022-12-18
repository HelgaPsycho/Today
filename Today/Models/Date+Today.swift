//
//  Date+Today.swift
//  Today
//
//  Created by Ольга Егорова on 18.12.2022.
//

import Foundation

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        //Passing .omitted for the date style creates a string of only the time component.
        if Locale.current.calendar.isDateInToday(self) {
          let timeFormat = NSLocalizedString("Today at %@", comment: "Today and time format string")
            return String(format: timeFormat, timeText)
        } else{
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    var dayText: String {
        let dateText = formatted(date: .abbreviated, time: .omitted)
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today format string")
        } else {
            return formatted(.dateTime.month().day().weekday())
        }
    }
}

