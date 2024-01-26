//
//  HomeInitialView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/23.
//

import SwiftUI
import Kingfisher

struct HomeInitialView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State var isExpanded = true
    
    var body: some View {
        VStack {
            List {
                Section {
                    Group {
                        ForEach(viewModel.currentWorkspace.channels) { channel in
                            ChannelCell(channel: channel)
                        }
                        HStack {
                            Image(.plusIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("채널 추가")
                        }
                    }
                    .foregroundColor(ColorSet.Text.secondary)
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("채널")
                        .foregroundStyle(ColorSet.Text.primary)
                        .frame(height: 56)
                }
                Section {
                    Group {
                        ForEach(viewModel.currentWorkspace.workspaceMembers) { member in
                            DMCell(user: member)
                        }
                        HStack {
                            Image(.plusIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("팀원 추가")
                        }
                    }
                    .padding(.leading, 2)
                    .foregroundColor(ColorSet.Text.secondary)
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("다이렉트 메세지")
                        .frame(height: 56)
                        .foregroundStyle(ColorSet.Text.primary)
                }
            }
            .listStyle(.plain)
            
        }
//        .onAppear() {
//            print(viewModel.currentWorkspace)
//        }
    }
}

struct ChannelCell: View {
    
    var channel: Channel
    
    var body: some View {
        HStack {
            Image(.hashtagIconThin)
                .resizable()
                .frame(width: 18, height: 18)
            Text(channel.name)
        }
        .frame(height: 41)
    }
}

struct DMCell: View {
    
    var user: WorkspaceMember
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://image.blip.kr/v1/file/b2595c70f5f7ffc48bec83400d0ecdcd"))
                .resizable()
                .cornerRadius(4)
                .frame(width: 24, height: 24)
                .padding(.trailing, 3)
            Text(user.nickname)
            Spacer()
        }
        .frame(height: 41)
    
    }
}
