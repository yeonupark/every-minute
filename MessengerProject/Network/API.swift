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
    case join(join: JoinModel)
}

extension MarAPI: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .emailValidation, .join:
            return URL(string: APIkeys.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "v1/users/validation/email"
        case .join:
            return "v1/users/join"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation, .join:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailModel(email: email))
        case .join(let join):
            return .requestJSONEncodable(join)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .join:
            ["Content-Type" : "application/json",
             "SesacKey" : APIkeys.sesacKey]
        }
    }
    
    
}
