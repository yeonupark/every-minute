//
//  OnboardingView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/07.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var isShowingBottomSheet = false
    
    var body: some View {
        
        VStack {
            
            Text("새싹톡을 사용하면 어디서나 \n팀을 모을 수 있습니다")
                .multilineTextAlignment(.center)
                .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
                .frame(width: 345, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(EdgeInsets(top: 39, leading: 24, bottom: 0, trailing: 24))
            
            Image(.onboarding).resizable()
                .frame(width: 368, height: 368)
                .padding(EdgeInsets(top: 89, leading: 12, bottom: 0, trailing: 12))
            
            Button(action: {
                withAnimation {
                    isShowingBottomSheet.toggle()
                }
            }, label: {
                Image(.startButton).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 345, height: 44)
                    .padding(EdgeInsets(top: 153, leading: 24, bottom: 24, trailing: 24))
            })
            .sheet(isPresented: $isShowingBottomSheet, content: {
                BottomSheetType.login.view()
                    .presentationCornerRadius(20)
                    .presentationDetents([.height(290)])
                    .presentationDragIndicator(.visible)
            })
            
            
        }
    }
}

enum BottomSheetType: Int {
    case login
    case join
    
    func view() -> AnyView {
        switch self {
        case .login:
            return AnyView(loginBottomSheet())
        case .join:
            return AnyView(loginBottomSheet())
        }
    }
}

struct loginBottomSheet: View {
    
    var body: some View {
        
        ColorSet.Brand.white
        
        VStack {
            
            Button(action: {
                print("애플로그인")
            }, label: {
                LoginButtonImage(buttonImage: Image(.appleLogin), topPadding: 42)
            })
            
            Button(action: {
                print("카카오로그인")
            }, label: {
                LoginButtonImage(buttonImage: Image(.kakaoLogin), topPadding: 12)
            })
            
            Button(action: {
                print("이메일로그인")
            }, label: {
                LoginButtonImage(buttonImage: Image(.emailLogin), topPadding: 12)
            })
            
            HStack {
                Text("또는")
                    .foregroundColor(ColorSet.Brand.black)
                Button(action: {
                    print("회원가입")
                }, label: {
                    Text("새롭게 회원가입 하기")
                        .foregroundColor(ColorSet.Brand.green)
                })
                
            }
            .fontWithLineHeight(font: Typography.title2.font, lineHeight: Typography.title2.lineHeight)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
        }
    }
    
}

struct LoginButtonImage: View {
    
    var buttonImage: Image
    var topPadding: CGFloat
    
    var body: some View {
        buttonImage.resizable().aspectRatio(contentMode: .fit)
            .frame(width: 323, height: 44)
            .padding(EdgeInsets(top: topPadding, leading: 16, bottom: 0, trailing: 16))
    }
}

#Preview {
    OnboardingView()
}
