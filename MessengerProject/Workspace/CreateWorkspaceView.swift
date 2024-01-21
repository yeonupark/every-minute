//
//  CreateWorkspaceView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/18.
//

import SwiftUI
import PhotosUI

struct CreateWorkspaceView: View {
    
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    @Binding var isShowingCreateView: Bool
    
    @ObservedObject var viewModel = CreateWorkspaceViewModel()
    
    //var image = Image(.chatIcon)
    
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
                        
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .frame(width: 48, height: 60)
                            .padding(.top, 10)
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Image(.cameraIcon)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .offset(x: 30, y: 30)
                        }
                        .onChange(of: selectedPhoto) { newPhoto in
                            Task {
                                if let data = try? await newPhoto?.loadTransferable(type: Data.self) {
                                    print(data)
                                    
                                    guard let image = UIImage(data: data) else { return }
                                    viewModel.image = image
                                    
                                    guard let compressedData = image.jpegData(compressionQuality: 0.1) else { return }
                                    print(compressedData)
                                    
                                    viewModel.imageString = compressedData.base64EncodedString()
                                    //print(viewModel.imageString)
                                    
                                }
                            }
                        }
                        
                    }
                    .padding(.top, 24)
                    InputField(label: "워크스페이스 이름", placeholder: "워크스페이스 이름을 입력하세요 (필수)", input: $viewModel.name)
                        .padding(.top, 16)
                    InputField(label: "워크스페이스 설명", placeholder: "워크스페이스를 설명하세요 (옵션)", input: $viewModel.description)
                        .padding(.top, 16)
                    Spacer()
                    Button(action: {
                        viewModel.createWorkspace()
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
