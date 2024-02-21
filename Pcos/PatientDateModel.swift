//
//  PatientDateModel.swift
//  Pcos
//
//  Created by Kathiravan on 15/02/24.
//

import Foundation

struct PatientDateModel: Codable {
    let name: String
    let dates: [DateElement]
}

// MARK: - DateElement
struct DateElement: Codable {
    let calendarDate: String

    enum CodingKeys: String, CodingKey {
        case calendarDate = "calendar_date"
    }
}
