//
//  Date+Extensions.swift
//  Pollexa
//
//  Created by Fikret Onur ÖZDİL on 22.05.2024.
//

import Foundation

extension TimeInterval {
    func timeAgoDisplay() -> String {
        let secondsInMinute = 60
        let secondsInHour = 3600
        let secondsInDay = 86400
        let secondsInWeek = 604800
        let secondsInMonth = 2592000
        let secondsInYear = 31536000

        if self < Double(secondsInMinute) {
            return "\(Int(self)) seconds ago"
        } else if self < Double(secondsInHour) {
            return "\(Int(self / Double(secondsInMinute))) minutes ago"
        } else if self < Double(secondsInDay) {
            return "\(Int(self / Double(secondsInHour))) hours ago"
        } else if self < Double(secondsInWeek) {
            return "\(Int(self / Double(secondsInDay))) days ago"
        } else if self < Double(secondsInMonth) {
            return "\(Int(self / Double(secondsInWeek))) weeks ago"
        } else if self < Double(secondsInYear) {
            return "\(Int(self / Double(secondsInMonth))) months ago"
        } else {
            return "\(Int(self / Double(secondsInYear))) years ago"
        }
    }
}
