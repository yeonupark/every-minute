//
//  ChatTable.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import RealmSwift

class ChatTable: Object, Identifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var workspace_id: Int
    @Persisted var channelName: String
    @Persisted var chat_id: Int
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String?>
    @Persisted var user: UserTable?
    
    convenience init(workspace_id: Int, channelName: String, chat_id: Int, content: String? = nil, createdAt: String, files: List<String?>, user: UserTable) {
        
        self.init()
        
        self.workspace_id = workspace_id
        self.channelName = channelName
        self.chat_id = chat_id
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}

class UserTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var user_id: Int
    @Persisted var email: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(user_id: Int, email: String, nickname: String, profileImage: String? = nil) {
        self.init()
        
        self.user_id = user_id
        self.email = email
        self.nickname = nickname
        self.profileImage = profileImage
    }
    
}
