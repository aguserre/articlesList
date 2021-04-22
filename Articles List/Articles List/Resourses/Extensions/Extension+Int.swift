//
//  Extension+Int.swift
//  Articles List
//
//  Created by Agustin Errecalde on 22/04/2021.
//

import UIKit

extension Int {
    func getIntervalFormattedString() -> String {
        let intervalToday = Date().timeIntervalSince1970
        let intervalDiff = Date(timeIntervalSince1970: intervalToday - TimeInterval(self)).timeIntervalSince1970

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]

        formatter.unitsStyle = .abbreviated
        
        guard let formattedString = formatter.string(from: intervalDiff) else {
            return ""
        }

        return " - \(formattedString)"
    }
}
