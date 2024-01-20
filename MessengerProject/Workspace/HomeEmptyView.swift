//
//  HomeEmptyView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/16.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    @State var isNewUser = false
    @Binding var isNewUserResult: Bool
    
    var body: some View {
        VStack {
            if viewModel.isEmptyView {
                HeaderView(workspaceName: "No Workspace")
            } else {
                HeaderView(workspaceName: viewModel.workspace[0].name)
            }
            Divider()
            Spacer()
            EmptyView()
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
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundColor(ColorSet.Brand.green)
                .padding()
            Text(workspaceName)
                .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
            Spacer()
            Image(systemName: "person.circle")
                .resizable()
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
