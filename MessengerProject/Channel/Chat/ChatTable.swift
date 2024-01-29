//
//  ChatTable.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import RealmSwift

class ChatTable: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var channel_id: Int
    @Persisted var channelName: String
    @Persisted var chat_id: Int
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var files: List<String?>
    @Persisted var user: Object
    
    convenience init(channel_id: Int, channelName: String, chat_id: Int, content: String? = nil, createdAt: String, files: List<String?>, user: Object) {
        
        self.init()
        
        self.channel_id = channel_id
        self.channelName = channelName
        self.chat_id = chat_id
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.user = user
    }
}
