//
//  SignUpView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/09.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel = SignUpViewModel()
    
    @Binding var isShowingBottomSheet: Bool
    @State var isShowingWorkspace = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack(alignment: .center, spacing: 24) {
                    
                    EmailField(label: "이메일", placeholder: "이메일을 입력하세요", input: $viewModel.email, viewModel: viewModel)
                        .padding(.top, 24)
                    InputField(label: "닉네임", placeholder: "닉네임을 입력하세요", input: $viewModel.nickname)
                    InputField(label: "연락처", placeholder: "전화번호를 입력하세요", input: $viewModel.phoneNumber)
                    InputField(label: "비밀번호", placeholder: "비밀번호를 입력하세요", input: $viewModel.password)
                    InputField(label: "비밀번호 확인", placeholder: "비밀번호를 한 번 더 입력하세요", input: $viewModel.passwordRepeat)
                    Spacer()
                    
                    Button(action: {
                        viewModel.callJoinRequest { result in
                            if result {
                                isShowingWorkspace = true
                            }
                        }
                    }, label: {
                        let image = viewModel.isValidLoginForm ? Image(.joinButtonEnabled) : Image(.joinButton)
                        image
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                    .fullScreenCover(isPresented: $isShowingWorkspace, content: {
                        WorkspaceInitialView()
                    })
                }
            }
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: closeBarButton(isShowingBottomSheet: $isShowingBottomSheet))
        }
        .onAppear {
            viewModel.fieldCheck()
        }
    }
}

struct InputField: View {
    
    let label: String
    let placeholder: String
    
    @Binding var input: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWithLineHeight(font: Typography.title2.font, lineHeight: Typography.title2.lineHeight)
                .padding(.bottom, 8)
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 345, height: 44)
                TextField(placeholder, text: $input)
                .fontWithLineHeight(font: Typography.caption.font, lineHeight: Typography.caption.lineHeight)
                .textFieldStyle(.plain)
                .frame(width: 335, height: 44)
            }
        }
    }
}

struct EmailField: View {
    
    let label: String
    let placeholder: String
    
    @Binding var input: String
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWithLineHeight(font: Typography.title2.font, lineHeight: Typography.title2.lineHeight)
                .padding(.bottom, 8)
            HStack {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 233, height: 44)
                    TextField(placeholder, text: $input)
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .textFieldStyle(.plain)
                    .frame(width: 223, height: 44)
                }
                Button(action: {
                    viewModel.callEmailValidation(email: viewModel.email) { result in
                        viewModel.isValidEmail = result
                    }
                }, label: {
                    let image = viewModel.isValidEmail ? Image(.emailButtonEnabled) : Image(.emailButton)
                    image
                        .resizable()
                        .frame(width: 100, height: 44)
                })
                
            }
        }
    }
}

struct closeBarButton: View {
    
    @Binding var isShowingBottomSheet: Bool
    
    var body: some View {
        Button(action: {
            isShowingBottomSheet = false
        }, label: {
            Image(.closeIcon)
                .resizable()
                .frame(width: 24, height: 24)
        })
    }
}
