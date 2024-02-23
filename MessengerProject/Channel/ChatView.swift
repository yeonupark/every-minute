//
//  ChatView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import SwiftUI
import Kingfisher

struct ChatView: View {
    
    @ObservedObject var viewModel = ChatViewModel()
    
    @State var channel: Channel
    
    @State private var bottomID: Int?
    
    var body: some View {
        VStack {
            ChatHeaderView(channel: $channel)
                .frame(height: 45)
            Divider()
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(viewModel.savedChat) { message in
                        ChatCell(message: message)
                            .id(message.chat_id)
                    }
                }
                .onAppear {
                    bottomID = viewModel.savedChat.last?.chat_id
                    if let bottomID = bottomID {
                        proxy.scrollTo(bottomID, anchor: .center)
                    }
                }
                .scrollDismissesKeyboard(.immediately)
            }
            ChatWriteView(viewModel: viewModel, channel: $channel)
        }
        .onAppear() {
            DispatchQueue.main.async {
                viewModel.savedChat = viewModel.chatRepository.fetch(channelName: channel.name)
                print("저장된채팅 개수: ", viewModel.savedChat.count)
                if viewModel.savedChat.isEmpty {
                    viewModel.fetchChat(date: "", name: channel.name, id: channel.workspaceID)
                }
                else { 
                    viewModel.checkUnreadMessages(id: channel.workspaceID, name: channel.name, after: viewModel.dateCursor) { result in
                        if result != 0 {
                            viewModel.fetchChat(date: viewModel.dateCursor, name: channel.name, id: channel.workspaceID)
                        }
                    }
                }
                SocketViewModel.shared.socket.connect()
            }
        }
        .onDisappear() {
            SocketViewModel.shared.socket.disconnect()
        }
            
    }
    
}

struct ChatHeaderView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var channel: Channel
    
    var body: some View {
        HStack {
            Image(.back)
                .resizable()
                .frame(width: 12, height: 20)
                .padding()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("# \(channel.name)")
                .font(.headline)
            Text("5")
                .foregroundColor(ColorSet.Text.secondary)
            Spacer()
            Image(.chatSetting)
                .resizable()
                .frame(width: 18, height: 18)
                .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

struct ChatCell: View {
    
    func dateFormat(dateString: String) -> String {
        let timeStartIndex = dateString.index(dateString.startIndex, offsetBy: 11)
            let timeEndIndex = dateString.index(dateString.startIndex, offsetBy: 16)
            let timeSubstring = dateString[timeStartIndex..<timeEndIndex]

            return String(timeSubstring)
    }
    
    var message: ChatTable //ChatResponse
    
    var body: some View {
        HStack(alignment: .top) {
            let thumbnailString = message.user?.profileImage == nil ? "https://image.blip.kr/v1/file/b2595c70f5f7ffc48bec83400d0ecdcd" : "\(APIkeys.baseURL)v1\(message.user!.profileImage!)"
            KFImage(URL(string: thumbnailString))
                .placeholder {
                    ProgressView()
                }
                .onFailure { error in
                    print("이미지 로딩 실패 ㅠㅠ: \(error)")
                }
                .resizable()
                .cornerRadius(4)
                .frame(width: 24, height: 24)
                .padding(.trailing, 3)
            VStack(alignment: .leading) {
                Text(message.user?.nickname ?? "")
                    .fontWithLineHeight(font: Typography.bodyBold.font, lineHeight: Typography.bodyBold.lineHeight)
                Spacer(minLength: 5)
                HStack(alignment: .bottom) {
                    Text(message.content ?? "")
                        .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorSet.Brand.inactive, lineWidth: 1)
                            // photo view
                        }
                    //.frame(maxWidth: 244, alignment: .leading)
                    Text(dateFormat(dateString: message.createdAt))
                        .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                        .foregroundColor(ColorSet.Text.secondary)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
    }
}

struct ChatWriteView: View {
    
    @ObservedObject var viewModel: ChatViewModel
    @Binding var channel: Channel
    
    var body: some View {
        HStack {
            Image(.plusIcon)
                .resizable()
                .frame(width: 22, height: 20)
                .padding(EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 1))
            TextField(text: $viewModel.content) {
                Text("메세지를 입력하세요")
                    .foregroundColor(ColorSet.Text.secondary)
            }
            let icon = viewModel.content.isEmpty ? Image(.chatSendIcon) : Image(.chatSendIconEnabled)
            Button(action: {
                viewModel.sendChat(channelName: channel.name, workspaceID: channel.workspaceID) { result in
                    if result != nil {
                        viewModel.content = ""
                        let userData = ["user_id" : result?.user.userID ?? "", "email" : result?.user.email ?? "", "nickname" : result?.user.nickname ?? "", "profileImage" : result?.user.profileImage ?? ""] as [String : Any]
                        
                        let dataArr = ["channelName" : result?.channelName ?? "", "createdAt" : result?.createdAt ?? "", "channel_id" : result?.channel_id ?? "", "chat_id" : result?.chat_id ?? "", "content" : result?.content ?? "ㅎㅇ", "files" : [], "user" : userData] as [String : Any]
                        SocketViewModel.shared.emit(with: dataArr)
                        //let message = [result]
//                        do {
//                            let jsonData = try JSONEncoder().encode(message)
//                            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                                let dataArr = ["channelName" : result?.channelName, "createdAt" : result?.createdAt, "channel_id" : result?.channel_id, "chat_id" : result?.chat_id] as [String : Any]
//                                SocketViewModel.shared.emit(with: dataArr)
//                            }
//                        } catch {
//                            print("Error encoding data to JSON: \(error)")
//                        }
                    }
                }
            }, label: {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
            })
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorSet.Background.primary)
        }
        .padding()
    }
}
