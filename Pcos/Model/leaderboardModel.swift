//
//  leaderboardModel.swift
//  Pcos
//
//  Created by SAIL on 03/01/24.
//
import Foundation

struct Leaderboard: Codable {
    var success: Bool
    var message: String
    var topScores: [TopScore]

    enum CodingKeys: String, CodingKey {
        case success, message
        case topScores = "top_scores"
    }
}

struct TopScore: Codable {
    let name: String
    let totalscore: Int
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case name = "Name", totalscore = "Totalscore"
        case profileImage = "ProfileImage"
    }
}



