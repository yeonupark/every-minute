//
//  HomeInitialView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/23.
//

import SwiftUI
import Kingfisher

struct HomeInitialView: View {
    
    @State var isShowingInviteMemberView = false
    @State var isShowingCreateChannelView = false
    @State var refreshWorkspace = false
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.currentWorkspace.channels) { channel in
                    NavigationLink {
                        ChatView(channel: channel)
                            
                    } label: {
                        ChannelCell(channel: channel)
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
            HStack {
                Image(.plusIcon)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("채널 추가")
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
            }
            .foregroundColor(ColorSet.Text.secondary)
            .onTapGesture {
                isShowingCreateChannelView = true
            }
            Section {
                ForEach(viewModel.currentWorkspace.workspaceMembers) { member in
                    DMCell(user: member)
                }
                .foregroundColor(ColorSet.Text.secondary)
                .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                .listRowSeparator(.hidden)
            } header: {
                Text("다이렉트 메세지")
                    .frame(height: 56)
                    .foregroundStyle(ColorSet.Text.primary)
            }
            HStack {
                Image(.plusIcon)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("팀원 추가")
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
            }
            .foregroundColor(ColorSet.Text.secondary)
            .onTapGesture {
                isShowingInviteMemberView = true
            }
        }
        .listStyle(.plain)
        .sheet(isPresented: $isShowingCreateChannelView, content: {
            CreateChannelView(homeViewModel: viewModel, isShowingCreateChannelSheet: $isShowingCreateChannelView)
        })
        .sheet(isPresented: $isShowingInviteMemberView, content: {
            MemberInviteView(homeViewModel: viewModel, isShowingMemberInviteView: $isShowingInviteMemberView)
        })
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
        //.frame(height: 41)
    }
}

struct DMCell: View {
    
    var user: WorkspaceMember
    
    var body: some View {
        HStack {
            let thumbnailString = user.profileImage == nil ? "https://image.blip.kr/v1/file/b2595c70f5f7ffc48bec83400d0ecdcd" : "\(APIkeys.baseURL)v1\(user.profileImage!)"
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
            Text(user.nickname)
            Spacer()
        }
    }
}
