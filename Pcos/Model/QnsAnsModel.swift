//
//  QnsAnsModel.swift
//  Pcos
//
//  Created by SAIL on 21/12/23.

import Foundation

// MARK: - Welcome
struct QnsAnsModel: Codable {
    let success: Bool
    let questions: [QuestionSubModel]
}

// MARK: - Question
struct QuestionSubModel: Codable {
    let questionID: Int
    let question: String
    let options: [OptionSubModel]

    enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case question, options
    }
}

// MARK: - Option
struct OptionSubModel: Codable {
    let optionText: String

    enum CodingKeys: String, CodingKey {
        case optionText = "option_text"
    }
}
