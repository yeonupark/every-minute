//
//  API.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/13.
//

import Foundation
import Moya

enum MarAPI {
    case emailValidation(email: String)
}

extension MarAPI: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .emailValidation:
            return URL(string: APIkeys.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "v1/users/validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailValidation(email: email))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation:
            ["Content-Type" : "application/json",
             "SesacKey" : APIkeys.sesacKey]
        }
    }
    
    
}
