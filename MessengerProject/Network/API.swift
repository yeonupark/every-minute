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
    case login(login: LoginModel)
    case getWorkspaces
}

extension MarAPI: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .emailValidation, .join, .login, .getWorkspaces:
            return URL(string: APIkeys.baseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .emailValidation:
            return "v1/users/validation/email"
        case .join:
            return "v1/users/join"
        case .login:
            return "v1/users/login"
        case .getWorkspaces:
            return "v1/workspaces"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation, .join, .login:
            return .post
        case .getWorkspaces:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .emailValidation(let email):
            return .requestJSONEncodable(EmailModel(email: email))
        case .join(let join):
            return .requestJSONEncodable(join)
        case .login(let login):
            return .requestJSONEncodable(login)
        case .getWorkspaces:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .join, .login:
            ["Content-Type" : "application/json",
             "SesacKey" : APIkeys.sesacKey]
        case .getWorkspaces:
            ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkeys.sesacKey]
        }
    }
    
    
}
