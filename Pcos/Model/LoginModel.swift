//
//  LoginModel.swift
//  Pcos
//
//  Created by Karthik Babu on 17/11/23.
//

import Foundation

// MARK: - Welcome
struct LoginModel: Codable {
    let success: Bool?
    let message: String?
    let role: String?
    let existingUser : Bool?
    
    enum CodingKeys: String, CodingKey {
        case success, message,role
        case existingUser = "existing_user"
    }
  
}

// MARK: - User
struct User: Codable {
    let id, username, password, email: String
    let role, createdOn: String

    enum CodingKeys: String, CodingKey {
        case id, username, password, email, role
        case createdOn = "created_on"
    }
}
