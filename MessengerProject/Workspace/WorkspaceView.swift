//
//  WorkspaceView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/23.
//

import SwiftUI

struct WorkspaceView: View {
    @State var isNewUserResult = false
    @Binding var isLogout: Bool
    
    var viewModel =  MyProfileViewModel()
    
    var body: some View {
        TabView {
            HomeInitialView()
                .tabItem {
                    Image(.tabHomeActive)
                    Text("홈")
                }
            Text("ㅎㅇ")
                .tabItem {
                    Image(.tabMessage)
                    Text("DM")
                }
            Text("ㅎㅇ")
                .tabItem {
                    Image(.tabProfile)
                    Text("검색")
                }
            Button(action: {
                viewModel.callLogout { result in
                    if result {
                        // 첫화면으로 화면 전환
                        isLogout = true
                    }
                }
            }, label: {
                Text("로그아웃")
            })
            .tabItem { 
                Image(.tabSetting)
                Text("설정")
            }
        }
        .accentColor(.black)
    }
}
