//
//  String.swift
//  theevent-poc
//
//  Created by Felipe Gil on 2023-10-21.
//

import Foundation

extension String {
    
    func splitISODateAndTime() -> (date: String, time: String)? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        
        if let date = formatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            let dateString = dateFormatter.string(from: date)
            let timeString = timeFormatter.string(from: date)
            
            return (date: dateString, time: timeString)
        }
        
        return nil
    }
}
