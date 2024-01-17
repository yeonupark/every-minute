//
//  LoginView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/14.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isRootViewOnboardingView: Bool
    @Binding var isNewUser: Bool
    
    @Binding var isShowingLoginView: Bool
    @ObservedObject var viewModel = LoginViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack(alignment: .center, spacing: 24) {
                    InputField(label: "이메일", placeholder: "이메일을 입력하세요", input: $viewModel.email)
                        .padding(.top, 24)
                    InputField(label: "비밀번호", placeholder: "비밀번호를 입력하세요", input: $viewModel.password)
                    Spacer()
                    
                    Button(action: {
                        viewModel.callLoginRequest { result in
                            if result {
                                isRootViewOnboardingView = false
                                isNewUser = false
                            }
                        }
                    }, label: {
                        let image = viewModel.isLoginAvailable ? Image(.loginButtonEnabled) : Image(.loginButton)
                        image
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                }
            }
            
            .navigationTitle("이메일 로그인")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: closeBarButton(isShowingBottomSheet: $isShowingLoginView))
        }
        .onAppear {
            viewModel.fieldCheck()
        }
    }
}
