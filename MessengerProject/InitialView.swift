//
//  InitialView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/17.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    //@State var isLogout = true
    @State var isNewUser = false
    
    var body: some View {
        
        if viewModel.isLogout {
            OnboardingView(isRootViewOnboardingView: $viewModel.isLogout, isNewUser: $isNewUser)
//                .onAppear() {
//                    viewModel.fetchWorkspaces()
//                }
        } else {
            HomeView(isNewUserResult: $isNewUser, isLogout: $viewModel.isLogout)
        }
    }
}

#Preview {
    InitialView()
}
