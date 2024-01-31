//
//  ChatViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import Moya

class ChatViewModel: ObservableObject {
    
    @Published var content = "무야호"
    
    @Published var channel: Channel = Channel(workspaceID: 0, channelID: 0, name: "한국영화", description: nil, ownerID: 0, channelPrivate: 0, createdAt: "")
    
    private let provider = MoyaProvider<MarAPI>()
    
    func sendChat(channelName: String, workspaceID: Int, completionHandler: @escaping (Bool) -> Void) {
        
        provider.request(.sendChat(channelName: channelName, workspaceID: workspaceID, content: "야호", files: [])) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(ChatResponse.self, from: response.data)
                        print("send chat success - ", response.statusCode, response.data)
                        print(result)
                        completionHandler(true)
                    } catch {
                        print("send chat decoding error - ")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("send chat failure - ", response.statusCode)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("send chat Error - ", error)
                completionHandler(false)
                
            }
        }
    }
    
    func fetchChat() {
        
    }
    
    func checkUnreadMessages() {
        
    }
}
