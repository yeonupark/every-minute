//
//  SocketViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import SocketIO

class SocketViewModel: ObservableObject {

    static var shared = SocketViewModel()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    init() {
        self.manager = SocketManager(socketURL: URL(string: "\(APIkeys.baseURL)ws-channel-300")!, config: [.log(false), .compress])
        self.socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 해제됨")
        }
        
        socket.onAny { (event) in
//            guard let data = try? JSONSerialization.data(withJSONObject: event, options: []) else {
//                return
//            }
//            let responseObj = String(data: data, encoding: .utf8) ?? "{}"
            print("=========")
            print(event.event, event.items as Any)
            print("*********")
            //print(event.event, responseObj as Any)
            
        }
        
        socket.on("channel") { dataArray, ack in
            print("소켓 수신 : \(dataArray)")
            if let json = dataArray.first as? [String: Any] {
                
                if let content = json["content"] as? String,
                   let user = json["user"] as? [String: Any],
                   let nickname = user["nickname"] as? String {
                    let message = "\(nickname): \(content)"
                    
                    print(message)
                }
            }
        }
        socket.connect(timeoutAfter: 0) {
            print("소켓 연결 상태: ", self.socket.status)
        }
        
        socket.connect()
    }
    
    func emit(event: String, with items: NSArray) {
        switch self.socket.status {
        case .notConnected:
            print("~~~ 연결안됨 ~~~", event)
            break
        case .disconnected:
            print("~~~ 연결 해제됨 ~~~", event)
            break
        case .connecting:
            print("~~~ 연결중 ~~~", event)
            self.socket.once(clientEvent: .connect) { object, ack in
                self.socket.emit(event, items)
                print("~~~ 연결 한번 됨 ~~~", event)
            }
        case .connected:
            self.socket.emit(event, items)
            print("emit 됐슴")
            print(items)
            break
        }
    }
    
}
