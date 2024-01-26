//
//  CreateChannelView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/26.
//

import SwiftUI

struct CreateChannelView: View {
    
    //@Binding var workspaceID: Int
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    @ObservedObject var createChannelViewModel = CreateChannelViewModel()
    @Binding var isShowingCreateChannelSheet: Bool
    
    var body: some View {
        
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack(alignment: .center, spacing: 24) {
                    InputField(label: "채널 이름", placeholder: "채널 이름을 입력하세요 (필수)", input: $createChannelViewModel.name)
                        .padding(.top, 24)
                    InputField(label: "채널 설명", placeholder: "채널을 설명하세요 (선택)", input: $createChannelViewModel.description)
                    Spacer()
                    
                    Button(action: {
                        createChannelViewModel.createChannel(workspaceID: homeViewModel.currentWorkspace.workspaceID) { result in
                            if result {
                                print(createChannelViewModel.newChannel)
                                isShowingCreateChannelSheet = false
                                // 홈뷰 갱신
                                homeViewModel.fetchOneWorkspace(id: homeViewModel.currentWorkspace.workspaceID)
                            }
                        }
                    }, label: {
                        let image = createChannelViewModel.isNameFieldFilled ? Image(.doneButtonEnabled) : Image(.doneButton)
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
            createChannelViewModel.fieldCheck()
        }
    }
}
//
//#Preview {
//    CreateChannelView()
//}
