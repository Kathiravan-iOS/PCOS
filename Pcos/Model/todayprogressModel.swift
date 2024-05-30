//
//  todayprogressModel.swift
//  Pcos
//
//  Created by SAIL on 27/12/23.
//

import Foundation
struct TodayProgressModel: Codable {
    let data: TodayProgressData?

    struct TodayProgressData: Codable {
        let Date: String?
        let calories_taken: Int?
        let exercise_duration: Int?
        let todays_feedback: Int?
        let no_of_steps: Int?
        let name: String?
    }
}



