//
//  Date.swift
//  TasksDiary
//
//  Created by Макс Понизов on 17.03.2025.
//

import Foundation

//Extension for custom methods to manipulate date
extension Date {
    ///This method return short date and time.
    public static func shortDateStyle(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    ///This method return date in string format
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//Extension for custom methods and variables to manipulate calendar
extension Calendar {
    ///This variable return 24 hours from current day.
    var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for index in 0..<24 {
            if let date = self.date(byAdding: .hour, value: index, to: startOfDay) {
                hours.append(date)
            }
        }
        return hours
    }
}
