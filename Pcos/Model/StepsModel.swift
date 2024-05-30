//
//  StepsModel.swift
//  Pcos
//
//  Created by SAIL on 12/02/24.
//

import Foundation

struct StepsDataModel: Codable {
    let success: Bool
    let message: String
    let days: [String]
    let stepsCounts: [Double] // Assuming steps counts are integers
    
    private enum CodingKeys: String, CodingKey {
        case success
        case message
        case days
        case stepsCounts = "steps_counts"
    }
}
