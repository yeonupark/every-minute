//
//  WorkspaceListView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/24.
//

import SwiftUI
import Kingfisher

struct WorkspaceListView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    @State var isShowingCreateView = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            ColorSet.Background.secondary
                .frame(width: 270)
            VStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    ColorSet.Background.primary
                    Text("워크스페이스")
                        .fontWithLineHeight(font: Typography.title1.font, lineHeight: Typography.title1.lineHeight)
                        .padding(.leading, 16)
                        .padding(.top, 50)
                    
                }
                .frame(height: 118)
                List(viewModel.workspaces) { item in
                    WorkspaceListCell(viewModel: viewModel, workspace: item)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                HStack {
                    Image(.plusIcon)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.leading, 18)
                    Text("워크스페이스 추가")
                        .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                        .foregroundColor(ColorSet.Text.secondary)
                }
                .frame(width: 270, alignment: .leading)
                .background(.white)
                .padding(.bottom, 20)
                .onTapGesture {
                    isShowingCreateView = true
                }
            }
            .mask(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .frame(width: 270)
            .ignoresSafeArea()
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $isShowingCreateView, content: {
            CreateWorkspaceView(isShowingCreateView: $isShowingCreateView)
                .presentationDragIndicator(.visible)
        })
    }
    
}

struct WorkspaceListCell: View {
    
    @State var isShowingAlert = false
    
    @ObservedObject var viewModel: HomeViewModel
    
    var workspace: WorkspacesResponseData
    
    func dateFormat(dateString: String) -> String {
        guard dateString.count >= 10 else {
                return ""
            }

            let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
            let endIndex = dateString.index(dateString.startIndex, offsetBy: 10)
            let dateSubstring = dateString[startIndex..<endIndex]

            return String(dateSubstring)
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: "\(APIkeys.baseURL)v1\(workspace.thumbnail)"))
                .resizable()
                .frame(width: 44, height: 44)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(workspace.name)
                    .fontWithLineHeight(font: Typography.bodyBold.font, lineHeight: Typography.bodyBold.lineHeight)
                Text(dateFormat(dateString: workspace.createdAt))
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .foregroundColor(ColorSet.Text.secondary)
            }
            Spacer()
            Button(action: {
                isShowingAlert = true
            }, label: {
                Image(.threeDotsIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            })
            .actionSheet(isPresented: $isShowingAlert, content: {
                ActionSheet(title: Text("워크스페이스 설정"), buttons: [
                    .default(Text("워크스페이스 편집"), action: {
                        print("편집편집")
                    }),
                    .default(Text("워크스페이스 나가기"), action: {
                        print("나가기")
                    }),
                    .default(Text("워크스페이스 관리자 변경"), action: {
                        print("관리자!")
                    }),
                    .destructive(Text("워크스페이스 삭제"), action: {
                        print("삭제삭제")
                        viewModel.deleteWorkspace(id: workspace.id) { result in
                            if result {
                                viewModel.fetchWorkspaces()
                            }
                        }
                    }),
                    .cancel(Text("취소"))
                ])
            })
        }
    }
}
