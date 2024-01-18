//
//  CreateWorkspaceView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/18.
//

import SwiftUI

struct CreateWorkspaceView: View {
    
    @State var name = ""
    @State var description = ""
    @Binding var isShowingCreateView: Bool
    
    @ObservedObject var viewModel = CreateWorkspaceViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSet.Background.primary
                VStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(ColorSet.Brand.green)
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                        Image(.chatIcon)
                            .resizable()
                            .frame(width: 48, height: 60)
                            .padding(.top, 10)
                        Image(.cameraIcon)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .offset(x: 30, y: 30)
                    }
                    .padding(.top, 24)
                    InputField(label: "워크스페이스 이름", placeholder: "워크스페이스 이름을 입력하세요 (필수)", input: $viewModel.name)
                        .padding(.top, 16)
                    InputField(label: "워크스페이스 설명", placeholder: "워크스페이스를 설명하세요 (옵션)", input: $viewModel.description)
                        .padding(.top, 16)
                    Spacer()
                    Button(action: {
                        print(viewModel.name)
                        print(viewModel.isNameFieldFilled)
                    }, label: {
                        let image = viewModel.isNameFieldFilled ? Image(.doneButtonEnabled) : Image(.doneButton)
                        image
                            .resizable()
                            .frame(width: 345, height: 44)
                    })
                    .padding(.bottom, 12)
                }
            }
            .navigationTitle("워크스페이스 생성")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: closeBarButton(isShowingBottomSheet: $isShowingCreateView))
        }
    }
}
