//
//  ChatView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var viewModel = ChatViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                ChatHeaderView()
                ScrollView {
                    ChatCell()
                    ChatCell()
                    ChatCell()
                    ChatCell()
                }
                ChatWriteView()
            }
        }
    }
}

#Preview {
    ChatView()
}

struct ChatHeaderView: View {
    var body: some View {
        HStack {
            Image(.back)
                .padding()
            Spacer()
            Text("# 한국영화")
                .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
            Text("14")
                .foregroundColor(ColorSet.Text.secondary)
            Spacer()
            Image(.chatSetting)
                .resizable()
                .frame(width: 18, height: 18)
                .padding()
        }
    }
}

struct ChatCell: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(.noPhotoIcon)
                .resizable()
                .frame(width: 34, height: 34)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text("고래밥")
                Spacer(minLength: 5)
                Text("저희 수료식이 언제였죠? 영등포 캠퍼스가 어디에 있었죠?")
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(ColorSet.Brand.inactive, lineWidth: 1)
                    }
                // photo view
            }
            .frame(maxWidth: 244)
            VStack {
                Spacer()
                Text("08:18 오전")
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .foregroundColor(ColorSet.Text.secondary)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
    }
}

struct ChatWriteView: View {
    
    @State var inputChat = ""
    
    var body: some View {
        HStack {
            Image(.plusIcon)
                .resizable()
                .frame(width: 22, height: 20)
                .padding(EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 1))
            TextField(text: $inputChat) {
                Text("메세지를 입력하세요")
                    .foregroundColor(ColorSet.Text.secondary)
            }
            let icon = inputChat.isEmpty ? Image(.chatSendIcon) : Image(.chatSendIconEnabled)
            icon
                .resizable()
                .frame(width: 24, height: 24)
                .padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorSet.Background.primary)
        }
        .padding()
    }
}
