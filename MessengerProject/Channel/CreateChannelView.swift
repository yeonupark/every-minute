//
//  CreateChannelView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/26.
//

import SwiftUI

struct CreateChannelView: View {
    
    @ObservedObject var viewModel = CreateChannelViewModel()
    @State var isShowingCreateChannelSheet = false
    var body: some View {
        
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack(alignment: .center, spacing: 24) {
                    InputField(label: "채널 이름", placeholder: "채널 이름을 입력하세요 (필수)", input: $viewModel.name)
                        .padding(.top, 24)
                    InputField(label: "채널 설명", placeholder: "채널을 설명하세요 (선택)", input: $viewModel.description)
                    Spacer()
                    
                    Button(action: {
                        viewModel.createChannel()
                    }, label: {
                        let image = viewModel.isNameFieldFilled ? Image(.doneButtonEnabled) : Image(.doneButton)
                        image
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                }
            }
            
            .navigationTitle("채널 생성")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: closeBarButton(isShowingBottomSheet: $isShowingCreateChannelSheet))
        }
        .onAppear {
            viewModel.fieldCheck()
        }
    }
}

#Preview {
    CreateChannelView()
}
