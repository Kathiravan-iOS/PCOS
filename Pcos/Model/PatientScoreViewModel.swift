//
//  PatientScoreViewModel.swift
//  Pcos
//
//  Created by SAIL on 05/02/24.
//
import Foundation


struct PaitentScoreModel: Codable {
    let success: Bool
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let mild, moderate, severe: Double
}
