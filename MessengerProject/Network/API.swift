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
    case logout
    case getWorkspaces
    case getOneWorkspace(id: Int)
    case createWorkspaces(model: NewWorkspacesModel)
    case deleteWorkspace(id: Int)
    case createChannel(id: Int, model: NewChannelModel)
    case inviteMember(id: Int, email: String)
    case sendChat(channelName: String, workspaceID: Int, content: String, files: [String])
    case checkUnreads(id: Int, name: String, after: String?)
}

extension MarAPI: Moya.TargetType {
    
    var baseURL: URL {
        switch self {
        case .emailValidation, .join, .login, .logout, .getWorkspaces, .getOneWorkspace, .createWorkspaces, .deleteWorkspace, .createChannel, .inviteMember, .sendChat, .checkUnreads:
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
        case .logout:
            return "v1/users/logout"
        case .getWorkspaces, .createWorkspaces:
            return "v1/workspaces"
        case .getOneWorkspace(let id), .deleteWorkspace(let id):
            return "v1/workspaces/\(id)"
        case .createChannel(let id, _):
            return "v1/workspaces/\(id)/channels"
        case .inviteMember(let id, _):
            return "v1/workspaces/\(id)/members"
        case .sendChat(let name, let id, _, _):
            return "v1/workspaces/\(id)/channels/\(name)/chats"
        case .checkUnreads(let id, let name, _):
            return "v1/workspaces/\(id)/channels/\(name)/unreads"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .emailValidation, .join, .login, .createWorkspaces, .createChannel, .inviteMember, .sendChat:
            return .post
        case .logout, .getWorkspaces, .getOneWorkspace, .checkUnreads:
            return .get
        case .deleteWorkspace:
            return .delete
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
        case .logout:
            return .requestPlain
        case .getWorkspaces, .getOneWorkspace:
            return .requestPlain
        case .createWorkspaces(let model):
            
            guard let imageData = Data(base64Encoded: model.image) else {
                return .requestPlain
            }
            
            let formData = [MultipartFormData(provider: .data(imageData),
                                              name: "image",
                                              fileName: "image.jpg",
                                              mimeType: "image/jpeg"),
                            MultipartFormData(provider: .data(model.name.data(using: .utf8)!),
                                              name: "name"),
                            MultipartFormData(provider: .data((model.description ?? "").data(using: .utf8)!),
                                              name: "description")]
            
            return .uploadMultipart(formData)
        case .deleteWorkspace:
            return .requestPlain
        case .createChannel(_, let model):
            return .requestJSONEncodable(NewChannelModel(name: model.name, description: model.description))
        case .inviteMember(_, let email):
            return .requestJSONEncodable(MemberInvite(email: email))
        case .sendChat(_, _, let content, let files):
            
            var formData: [MultipartFormData] = []
            
            for file in files {
                guard let imageData = Data(base64Encoded: file) else {
                    return .requestPlain
                }
                formData.append(MultipartFormData(provider: .data(imageData), name: "image", fileName: "image.jpg", mimeType: "image/jpeg"))
            }
            formData.append(MultipartFormData(provider: .data(content.data(using: .utf8)!), name: "content"))
            
            return .uploadMultipart(formData)
        case .checkUnreads(_, _, let after):
            return .requestParameters(parameters: ["after" : after], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .join, .login:
            ["Content-Type" : "application/json",
             "SesacKey" : APIkeys.sesacKey]
        case .logout, .getWorkspaces, .getOneWorkspace, .deleteWorkspace, .createChannel, .inviteMember, .checkUnreads:
            ["Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkeys.sesacKey]
        case .createWorkspaces, .sendChat:
            ["Content-Type" : "multipart/form-data",
             "Authorization" : UserDefaults.standard.string(forKey: "token") ?? "",
             "SesacKey" : APIkeys.sesacKey]
        }
    }
    
    
}
