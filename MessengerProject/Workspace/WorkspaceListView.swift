//
//  WorkspaceListView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/24.
//

import SwiftUI
import Kingfisher

struct WorkspaceListView: View {
    
    @Binding var workspaces: [WorkspacesResponseData]
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
                List(workspaces) { item in
                    WorkspaceListCell(imageThumbnail: item.thumbnail, name: item.name, createdAt: item.createdAt)
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
        .fullScreenCover(isPresented: $isShowingCreateView, content: {
            CreateWorkspaceView(isShowingCreateView: $isShowingCreateView)
        })
    }
    
}

struct WorkspaceListCell: View {

    var imageThumbnail: String
    var name: String
    var createdAt: String
    
    func dateFormat(originalString: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yy.MM.dd"
        let convertedDate = dateFormatter.date(from: originalString) ?? Date()
        let result = dateFormatter.string(from: convertedDate)
        return result
    }
    
    var body: some View {
        HStack {
            KFImage(URL(string: "\(APIkeys.baseURL)v1\(imageThumbnail)"))
                .resizable()
                .frame(width: 44, height: 44)
                .cornerRadius(8)
            VStack {
                Text(name)
                    .fontWithLineHeight(font: Typography.bodyBold.font, lineHeight: Typography.bodyBold.lineHeight)
                Text(dateFormat(originalString: createdAt))
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .foregroundColor(ColorSet.Text.secondary)
            }
            Spacer()
            Button(action: {
                
            }, label: {
                Image(.threeDotsIcon)
            })
        }
    }
}

//#Preview {
//    WorkspaceListView()
//}
