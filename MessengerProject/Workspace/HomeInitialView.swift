//
//  HomeInitialView.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/23.
//

import SwiftUI

struct HomeInitialView: View {
    @State var isExpanded = true
    var body: some View {
            List {
                Section {
                    Group {
                        HStack {
                            Image(.hashtagIconThin)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("일반")
                        }
                        HStack {
                            Image(.plusIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("팀원 추가")
                        }
                    }
                    .foregroundColor(ColorSet.Text.secondary)
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("채널")
                        .foregroundStyle(ColorSet.Text.primary)
                        .frame(height: 56)
                }
                
                Section {
                    Group {
                        HStack {
                            Image(.plusIcon)
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("팀원 추가")
                        }
                    }
                    .foregroundColor(ColorSet.Text.secondary)
                    .fontWithLineHeight(font: Typography.bodyRegular.font, lineHeight: Typography.bodyRegular.lineHeight)
                    .listRowSeparator(.hidden)
                } header: {
                    Text("다이렉트 메세지")
                        .frame(height: 56)
                        .foregroundStyle(ColorSet.Text.primary)
                }
            }
            .listStyle(.plain)

    }
}

#Preview {
    HomeInitialView()
}
