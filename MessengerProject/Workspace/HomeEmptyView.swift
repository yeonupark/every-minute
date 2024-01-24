//
//  HomeEmptyView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/16.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    @State var isNewUser = false
    @Binding var isNewUserResult: Bool
    
    @Binding var isLogout: Bool
    
    var body: some View {
        VStack {
            if viewModel.isEmptyView {
                HeaderView(workspaceName: "No Workspace", workspaceImageThumbnail: "")
                Divider()
                Spacer()
                EmptyView()
                Divider()
            } else {
                HeaderView(workspaceName: viewModel.workspace[0].name, workspaceImageThumbnail: viewModel.workspaceImageThumbnail)
                Divider()
                Spacer()
                //HomeInitialView()
                WorkspaceView(isLogout: $isLogout)
            }
            
        }
        .onAppear() {
            DispatchQueue.main.async {
                //viewModel.fetchWorkspaces()
                isNewUser = isNewUserResult
            }
            
        }
        .fullScreenCover(isPresented: $isNewUser, content: {
            WorkspaceInitialView()
        })
    }
}

struct HeaderView: View {
    
    var workspaceName: String
    var workspaceImageThumbnail: String
    
    var body: some View {
        HStack {
            KFImage(URL(string: workspaceImageThumbnail))
                .placeholder {
                    ProgressView()
                }
                .onFailure { error in
                    print("이미지 로딩 실패 ㅠㅠ: \(error)")
                }
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(10)
                .padding(.leading, 16)
            
            Text(workspaceName)
                .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
            Spacer()
            KFImage(URL(string: "https://image.blip.kr/v1/file/b2595c70f5f7ffc48bec83400d0ecdcd"))
                .resizable()
                .cornerRadius(16)
                .frame(width: 32, height: 32)
                .padding()
        }
    }
}

struct EmptyView: View {
    
    @State var isShowingCreateView = false
    
    var body: some View {
        VStack {
            Text("워크스페이스를 찾을 수 없어요.")
                .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
                .padding(.top, 35)
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나\n 새로운 워크스페이스를 생성해주세요. ")
                .multilineTextAlignment(.center)
                .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                .padding(.top, 24)
            Image(.workspaceEmpty)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 13)
                .padding(.top, 15)
            Spacer()
            Button(action: {
                isShowingCreateView = true
            }, label: {
                Image(.makeWorkspaceButton)
                    .resizable()
                    .frame(width: 345, height: 44)
            })
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $isShowingCreateView, content: {
            CreateWorkspaceView(isShowingCreateView: $isShowingCreateView)
        })
        
    }
}
