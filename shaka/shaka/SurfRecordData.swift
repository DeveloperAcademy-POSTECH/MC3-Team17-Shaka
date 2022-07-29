//
//  SurfRecordData.swift
//  shaka
//
//  Created by 유정인 on 2022/07/29.
//

import Foundation
import UIKit

struct SurfRecordData {
    let date: String
    let time: String
    let totalSecond: String
    let standSecond: String
    let degreeOfStand: DegreeOfStand
}

enum DegreeOfStand {
    case low
    case middle
    case high
    case complete
    
    var cellBackground: UIColor {
        switch self {
        case .low:
            return .cellBackgroundLightGray!
        case .middle:
            return .cellBackgroundGray!
        case .high:
            return .cellBackgroundLightBlue!
        case .complete:
            return .cellBackgroundBlue!
        }
    }
}
