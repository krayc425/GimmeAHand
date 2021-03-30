//
//  TimeIntervalExtensions.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 3/30/21.
//

import Foundation

extension TimeInterval {
    
    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var formattedETAString: String {
        var arr: [String] = []
        if hours != 0 {
            arr.append("\(hours)h")
        }
        if minutes != 0 {
            arr.append("\(minutes)m")
        }
        if seconds != 0 {
            arr.append("\(seconds)s")
        }
        return arr.joined(separator: " ")
    }
    
}
