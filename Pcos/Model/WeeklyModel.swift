//
//  WeeklyModel.swift
//  Pcos
//
//  Created by SAIL on 15/04/24.
//

import Foundation
struct WeeklyModel: Codable {
    let success: Bool
    let message: String
    let data: [WeeklyProgress]
}

// MARK: - Datum
struct WeeklyProgress: Codable {
    let day, caloriesTaken, exerciseDuration, todaysFeedback: Int
    let noOfSteps: Int
    let date: String

    enum CodingKeys: String, CodingKey {
            case day
            case caloriesTaken = "calories_taken"
            case exerciseDuration = "exercise_duration"
            case todaysFeedback = "todays_feedback"
            case noOfSteps = "no_of_steps"
            case date
        }
}
