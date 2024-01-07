//
//  OnboardingView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/07.
//

import SwiftUI

struct OnboardingView: View {
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
                print("시작")
            }, label: {
                Image(.startButton).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 345, height: 44)
                    .padding(EdgeInsets(top: 153, leading: 24, bottom: 24, trailing: 24))
            })
        }
    }
}

#Preview {
    OnboardingView()
}
