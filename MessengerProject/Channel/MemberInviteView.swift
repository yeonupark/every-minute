//
//  MemberInviteView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/26.
//

import SwiftUI

struct MemberInviteView: View {
    
    @ObservedObject var homeViewModel: HomeViewModel
    
    @ObservedObject var memberInviteViewModel = MemberInviteViewModel()
    @Binding var isShowingMemberInviteView: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack(alignment: .center, spacing: 24) {
                    InputField(label: "이메일", placeholder: "초대하려는 팀원의 이메일을 입력하세요", input: $memberInviteViewModel.email)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    Button(action: {
                        memberInviteViewModel.inviteMember(id: homeViewModel.currentWorkspace.workspaceID) { result in
                            if result {
                                homeViewModel.fetchOneWorkspace(id: homeViewModel.currentWorkspace.workspaceID)
                                isShowingMemberInviteView = false
                            }
                        }
                    }, label: {
                        let image = memberInviteViewModel.idEmailFieldFilled ? Image(.inviteButtonEnabled) : Image(.inviteButton)
                        image
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                }
            }
            
            .navigationTitle("팀원 초대")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: closeBarButton(isShowingBottomSheet: $isShowingMemberInviteView))
        }
    }
}
