//
//  WorkspaceInitialView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/15.
//

import SwiftUI

struct WorkspaceInitialView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                    .ignoresSafeArea(edges: .bottom)
                VStack(alignment: .center) {
                    Text("출시 준비 완료!")
                        .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
                        .frame(width: 345, height: 30)
                        .padding(.top, 35)
                    Text("\(UserDefaults.standard.string(forKey: "nickname") ?? "익명")님의 조직을 위해 새로운 새싹톡 워크스페이스를 시작할 준비가 완료되었어요!")
                        .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                        .multilineTextAlignment(.center)
                        .frame(width: 345, height: 40)
                        .padding(.top, 24)
                    Image(.launching)
                        .resizable()
                        .frame(width: 368, height: 368)
                        .padding(.top, 15)
                    Spacer()
                    Button(action: {
                        print("워크스페이스생성")
                    }, label: {
                        Image(.makeWorkspaceButton)
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                    .padding(.bottom, 24)
                }
            }
                .navigationTitle(Text("시작하기"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: closeBarButton2(presentationMode: presentationMode))
        }
    }
}

#Preview {
    WorkspaceInitialView()
}

struct closeBarButton2: View {
    
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.dismiss()
        }, label: {
            Image(.closeIcon)
                .resizable()
                .frame(width: 24, height: 24)
        })
    }
}
