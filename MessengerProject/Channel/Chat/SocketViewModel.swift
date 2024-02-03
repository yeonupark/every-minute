//
//  SocketViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import SocketIO

class SocketViewModel: ObservableObject {
    
    var socketManager: SocketManager?
    
    //@Published var channelID = 0
    @Published var isConnected = false
    @Published var receivedMessage: ChatResponse?
    
    var socket: SocketIOClient!
    
    init() {
        //connect()
    }
    
    
    func connect(channelID: Int) {
        guard let url = URL(string: "\(APIkeys.baseURL)ws-channel-\(channelID)") else {
            return
        }
        socketManager = SocketManager(socketURL: url, config: [.log(true), .compress])
        print(url)
        
        socketManager?.defaultSocket.on(clientEvent: .error) { data, ack in
            if let error = data.first as? String {
                print("Error during connection:", error)
            }
        }

        socketManager?.defaultSocket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨", data, ack)
            self.isConnected = true
        }
        
        socketManager?.defaultSocket.on("channel") { data, ack in
            print("CHANNEL RECEIVED", data, ack)
        }
    }
    
    func disconnect() {
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 해제됨", data, ack)
            self.isConnected = false
        }
    }
    
}
