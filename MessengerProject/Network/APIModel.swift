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
    let user_id: Int
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

struct LoginModel: Encodable {
    let email: String
    let password: String
    let deviceToken: String?
}

struct LoginResponse: Decodable {
    let user_id: Int
    let nickname: String
    let accessToken: String
    let refreshToken: String
}

struct WorkspacesResponseData: Decodable, Identifiable {
    
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    
    var id: Int {
        return workspace_id
    }
}

struct NewWorkspacesModel: Encodable {
    let name: String
    let description: String?
    let image: String
}

/*
struct OneWorkspaceData: Decodable {
    
    let workspace_id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let owner_id: Int
    let createdAt: String
    
    let channels: [ChannelData]
    let workspaceMembers: [UserData]
}

struct ChannelData: Decodable {
    let workspace_id: Int
    let channel_id: Int
    let name: String
    let description: String?
    let owner_id: Int
    let `private`: Bool?
    let createdAt: String
}

struct UserData: Decodable {
    let user_id: Int
    let email: String
    let nickname: String
    let profileImage: String?
}

*/

struct OneWorkspaceData: Codable {
    let workspaceID: Int
    let description: String?
    let name, thumbnail: String
    let ownerID: Int
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [WorkspaceMember]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt, channels, workspaceMembers
    }
}

// MARK: - Channel
struct Channel: Codable, Identifiable {
    let workspaceID, channelID: Int
    let name: String
    let description: String?
    let ownerID, channelPrivate: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case channelPrivate = "private"
        case createdAt
    }
    
    var id: Int {
        return channelID
    }
}

// MARK: - WorkspaceMember
struct WorkspaceMember: Codable, Identifiable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
    
    var id: Int {
        return userID
    }
}

