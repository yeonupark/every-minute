//
//  ChatViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import Moya

class ChatViewModel: ObservableObject {
    
    @Published var dateCursor = "2024-01-29T12:51:51.292Z"
    @Published var messages: [ChatResponse] = []
    @Published var content = ""
    
    //@Published var channel: Channel = Channel(workspaceID: 0, channelID: 0, name: "한국영화", description: nil, ownerID: 0, channelPrivate: 0, createdAt: "")
    
    private let provider = MoyaProvider<MarAPI>()
    
    func sendChat(channelName: String, workspaceID: Int, completionHandler: @escaping (Bool) -> Void) {
        
        provider.request(.sendChat(channelName: channelName, workspaceID: workspaceID, content: content, files: [])) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(ChatResponse.self, from: response.data)
                        print("send chat success - ", response.statusCode, response.data)
                        print(result)
                        completionHandler(true)
                    } catch {
                        print("send chat decoding error - ", error.localizedDescription)
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
    
    func fetchChat(date: String, name: String, id: Int) {
        
        provider.request(.getMessages(cursor_date: date, name: name, id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let resultData = try JSONDecoder().decode([ChatResponse].self, from: response.data)
                        print("fetch chat success - ", response.statusCode, response.data)
                        self.messages = resultData
                    } catch {
                        print("fetch chat decoding error - ", error)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("fetch chat failure - ", response.statusCode)
                }
            case .failure(let error):
                print("fetch chat Error - ", error)
            }
        }
    }
    
    func checkUnreadMessages(id: Int, name: String, after: String, completionHandler: @escaping (Int) -> Void) {
        print("애프터: ", after)
        provider.request(.checkUnreads(id: id, name: name, after: after)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let resultData = try JSONDecoder().decode(UnreadMessagesResponse.self, from: response.data)
                        print("checkunreads success - ", response.statusCode, response.data)
                        print(resultData)
                        completionHandler(resultData.count)
                    } catch {
                        print("checkunreads decoding error - ")
                        completionHandler(0)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("checkunreads failure - ", response.statusCode)
                    completionHandler(0)
                }
            case .failure(let error):
                print("checkunreads chat Error - ", error)
                completionHandler(0)
            }
        
        }
    }
}
