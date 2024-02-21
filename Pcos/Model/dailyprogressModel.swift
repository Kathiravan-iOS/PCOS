//
//  dailyprogressModel.swift
//  Pcos
//
//  Created by SAIL on 16/12/23.
//

import Foundation
struct progressModel: Codable{
    let success : Bool
    let message : String
}
struct Progress: Codable {
    let name: String
    let day: String
    let calories_taken: String
    let exercise_duration: String
    let todays_feedback: String
    let no_of_steps: String
}
