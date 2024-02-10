//
//  ChatViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import Combine
import Moya
import Realm
import RealmSwift

class ChatViewModel: ObservableObject {
    
    let chatRepository = ChatTableRepository()
    
    @Published var savedChat: Results<ChatTable>
    @Published var dateCursor = ""
    @Published var content = ""

    init() {
        savedChat = chatRepository.fetch(channelName: "")
        setDateCursor()
        //checkRealm()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func setDateCursor() {
        $savedChat
            .map { tablelist in
                return tablelist.last?.createdAt ?? ""
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.dateCursor, on: self)
            .store(in: &cancellables)
    }
    
    func checkRealm() {
        chatRepository.printRealmLocation()
        chatRepository.checkSchemaVersion()
        //print("저장된 채팅: ", savedChat)
    }
    
    func saveToRealm(workspaceID: Int, newChat: ChatResponse) {
        let filesList = List<String?>()
        filesList.append(objectsIn: newChat.files)
        let userTable = UserTable(user_id: newChat.user.userID, email: newChat.user.email, nickname: newChat.user.nickname, profileImage: newChat.user.profileImage)
        let chatTable = ChatTable(workspace_id: workspaceID, channelName: newChat.channelName, chat_id: newChat.chat_id, content: newChat.content, createdAt: newChat.createdAt, files: filesList, user: userTable)
        chatRepository.addItem(item: chatTable)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func sendChat(channelName: String, workspaceID: Int, completionHandler: @escaping (ChatResponse?) -> Void) {
        
        provider.request(.sendChat(channelName: channelName, workspaceID: workspaceID, content: content, files: [])) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(ChatResponse.self, from: response.data)
                        print("send chat success - ", response.statusCode, response.data)
                        
                        self.saveToRealm(workspaceID: workspaceID, newChat: result)
                        self.savedChat = self.chatRepository.fetch(channelName: channelName)
                        completionHandler(result)
                    } catch {
                        print("send chat decoding error - ", error.localizedDescription)
                        completionHandler(nil)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("send chat failure - ", response.statusCode)
                    completionHandler(nil)
                    
                }
            case .failure(let error):
                print("send chat Error - ", error)
                completionHandler(nil)
                
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
                    
                        for data in resultData {
                            self.saveToRealm(workspaceID: id, newChat: data)
                        }
                        self.savedChat = self.chatRepository.fetch(channelName: name)
                        
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
                        let unreads = resultData.count
                        print("checkunreads success - ", unreads)
                        completionHandler(unreads)
                    } catch {
                        print("checkunreads decoding error - ")
                        completionHandler(0)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: response.data)
                        print("checkunreads failure - ", response.statusCode, errorResponse.errorCode)
                        completionHandler(0)
                    } catch {
                        print("checkunreads decoding error - ")
                        completionHandler(0)
                    }
                }
            case .failure(let error):
                print("checkunreads chat Error - ", error)
                completionHandler(0)
            }
        
        }
    }
}
