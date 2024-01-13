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

struct EmailValidation: Encodable {
    let email: String
}

