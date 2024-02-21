//
//  leaderboardModel.swift
//  Pcos
//
//  Created by SAIL on 03/01/24.
//
import Foundation

// MARK: - Welcome
struct leaderboard: Codable {
    var success: Bool?
    var message: String?
    var topScores: [TopScore]?

    enum CodingKeys: String, CodingKey {
        case success, message
        case topScores = "top_scores"
    }
}

// MARK: - TopScore
struct TopScore: Codable {
    var name: String, totalscore: Int?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case totalscore = "Totalscore"
    }
}
