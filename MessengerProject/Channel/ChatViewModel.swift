//
//  ChatViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var channel: Channel = Channel(workspaceID: 0, channelID: 0, name: "한국영화", description: nil, ownerID: 0, channelPrivate: 0, createdAt: "")
    
}
