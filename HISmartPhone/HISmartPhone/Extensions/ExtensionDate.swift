//
//  ExtensionDate.swift
//  HISmartPhone
//
//  Created by DINH TRIEU on 1/9/18.
//  Copyright © 2018 MACOS. All rights reserved.
//

import UIKit

extension Date {
    
    /**
     with format: YYY-MM-dd
     */
    func getDesciptionYYYMMddHHmmss() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formater.string(from: self)
    }
    
    /**
     with format: YYY-MM-dd
     */
    func getDesciption() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        return formater.string(from: self)
    }
    
    /**
     with format: HH:mm:ss
     */
    func getTimeDescription() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm:ss"
        return formater.string(from: self)
    }
    
    /**
     with format: dd-MM-YYYY
     */
    func getDescription_DDMMYYYY() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        return formater.string(from: self)
    }
    
    /**
     with format: dd/MM/YYYY-HHmmss
     */
    func getDescription_DDMMYYYY_HHMMSS() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return formater.string(from: self)
    }
    
    /**
     with format: dd/MM
     */
    func getDescptionDateChart() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM"
        return formater.string(from: self)
    }
    
    /**
     with format: dd/MM/YYYY
     */
    func getDescription_DDMMYYYY_WithSlash() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd/MM/yyyy"
        return formater.string(from: self)
    }
    
    
    /**
     get timestamp for massage
     */
    func getTimestap()->String {
        let now = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let diff = Calendar.current.dateComponents(components, from: self, to: now)
        
        var timeText = ""
        if diff.second! <= 0 {
            timeText = "Vừa xong"
        }
        if diff.second! > 0 && diff.minute! == 0 {
            timeText = (diff.second == 1) ? "\(diff.second!) giây trước" : "\(diff.second!) giây trước"
        }
        if diff.minute! > 0 && diff.hour! == 0 {
            timeText = (diff.minute == 1) ? "\(diff.minute!) phút trước" : "\(diff.minute!) phút trước"
        }
        if diff.hour! > 0 && diff.day! == 0 {
            timeText = (diff.hour == 1) ? "\(diff.hour!) giờ trước" : "\(diff.hour!) giờ trước"
        }
        if diff.day! > 0 && diff.weekOfMonth! == 0 {
            timeText = (diff.day == 1) ? "\(diff.day!) ngày trước" : "\(diff.day!) ngày trước"
        }
        if diff.weekOfMonth! > 0 {
            timeText = self.getDescription_DDMMYYYY_WithSlash()
        }
        
        return timeText
    }
    
    func getOld() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date()) - calendar.component(.year, from: self)
    }
    
    static func get10DayAfter(_ date: Date) -> Date {
        let result = Calendar.current.date(byAdding: .day, value: 10, to: date) ?? Date()
        if result > Date() {
            return Date()
        } else {
            return result
        }
    }
    
    static func getDayBeforeOrAfter(_ date: Date, _ numberOfDay: Int = Constant.dayLoadChart) -> Date {
        return Calendar.current.date(byAdding: .day, value: numberOfDay, to: date) ?? Date()
    }
    
    static func getXDayBefore(from date: Date, _ x: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -x, to: date) ?? Date()
    }
    
    static func distanceDay(from fromDate: Date, to toDate: Date) -> Int {
        let calendar = Calendar.current
        return abs(calendar.component(.day, from: fromDate) - calendar.component(.day, from: toDate))
    }
    
    static func getDescptionTimeForMessage(from date: Date) -> String {
        let components = Set<Calendar.Component>([.minute, .hour, .day, .month, .year])
        let dateComponents = Calendar.current.dateComponents(components, from: date)
        
        let monthText: String = dateComponents.month ?? 0 < 10 ? "0\(dateComponents.month?.description ?? "")" : "\(dateComponents.month?.description ?? "")"
        let dayText: String = dateComponents.day ?? 0 < 10 ? "0\(dateComponents.day?.description ?? "")" : "\(dateComponents.day?.description ?? "")"
//        let hourText: String = dateComponents.hour ?? 0 < 10 ? "0\(dateComponents.hour?.description ?? "")" : "\(dateComponents.hour?.description ?? "")"
//        let minuteText: String = dateComponents.minute ?? 0 < 10 ? "0\(dateComponents.minute?.description ?? "")" : "\(dateComponents.minute?.description ?? "")"
        
        return "\(dayText)/\(monthText)/\(dateComponents.year ?? 0)"
    }
    
}








