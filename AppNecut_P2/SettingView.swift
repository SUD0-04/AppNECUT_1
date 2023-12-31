//
//  SettingView.swift
//  AppNecut_P2
//
//  Created by Kngmin Kang on 12/22/23.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("SETTINGS")
                .font(.system(size: 60, weight: .bold))
                .padding(.bottom, 270)
            Button(action: {
                // 버튼을 눌렀을 때 실행할 액션
            }) {
                Text("개인정보처리방침")
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            
            Button(action: {
                // 버튼을 눌렀을 때 실행할 액션
            }) {
                Text("이 앱에 대하여     ")
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            
            Button(action: {
                // 버튼을 눌렀을 때 실행할 액션
            }) {
                Text("Ver. BETA 1        ")
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
}

#Preview {
    SettingView()
}
