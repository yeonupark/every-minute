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
    
    var manager = SocketManager(socketURL: URL(string: "\(APIkeys.baseURL)ws-channel-300")!, config: [.log(true)])
    var socket: SocketIOClient!
    
    init() {
        self.socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("소켓 연결됨")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("소켓 연결 해제됨")
        }
        
//        socket.onAny { (event) in
//            print("=========")
//            print(event.event, event.items as Any)
//            print("*********")
//            
//        }
        
        socket.on("channel") { dataArray, ack in
            print("CHANNEL RECEIVED", dataArray, ack)
        }
        
//        socket.on("channel") { dataArray, ack in
//            print("소켓 수신 : \(dataArray)")
//            if let json = dataArray.first as? [String: Any] {
//                
//                if let content = json["content"] as? String,
//                   let user = json["user"] as? [String: Any],
//                   let nickname = user["nickname"] as? String {
//                    let message = "\(nickname): \(content)"
//                    
//                    print(message)
//                }
//            }
//        }
//        socket.connect(timeoutAfter: 0) {
//            print("소켓 연결 상태: ", self.socket.status)
//        }
        
        socket.connect()
    }
    
    func emit(with items: [String: Any]) {
        switch self.socket.status {
        case .notConnected:
            print("~~~ 연결안됨 ~~~", "channel")
            break
        case .disconnected:
            print("~~~ 연결 해제됨 ~~~", "channel")
            break
        case .connecting:
            print("~~~ 연결중 ~~~", "channel")
            self.socket.once(clientEvent: .connect) { object, ack in
                self.socket.emit("channel", items)
                print("~~~ 연결 한번 됨 ~~~", "channel")
            }
        case .connected:
            self.socket.emit("channel", items) {
                print("emit 됐슴")
                print(items)
            }
            //self.socket.emitWithAck("channel", items)
            
        }
    }
    
}
