//
//  APIModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/13.
//

import Foundation

struct ErrorModel: Codable, Error {
    var code : String = ""

    var msg : String? = ""
}

struct EmailModel: Encodable {
    let email: String
}

struct JoinModel: Encodable {
    let email: String
    let nickname: String
    let password: String
    let phone: String?
    let deviceToken: String?
}

struct JoinResponse: Decodable {
    let user_id: String
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: Token?
}

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}
