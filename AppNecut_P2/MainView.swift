//
//  ContentView.swift
//  AppNecut_P2
//
//  Created by Kngmin Kang on 12/22/23.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @State private var showCamera = false
    @Environment(\.colorScheme) var colorScheme // 현재 컬러 스킴을 가져옵니다.
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("APP\nNECUT")
                        .font(.system(size: 90, weight: .bold))
                        .padding(.top, 80)
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: CameraView(), isActive: $showCamera) {
                            EmptyView()
                        }
                        Button(action: {
                            AVCaptureDevice.requestAccess(for: .video) { response in
                                if response {
                                    self.showCamera = true
                                }
                            }
                        }) {
                            Text("SHOT")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(colorScheme == .dark ? .black : .white) // 다크 모드일 때는 글씨를 검은색으로 변경
                                .frame(width: 100, height: 100)
                                .background(colorScheme == .dark ? Color.white : Color.black) // 다크 모드일 때는 배경을 흰색으로 변경
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.bottom, 50)
                }
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingView()) {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(colorScheme == .dark ? .white : .black) // 다크 모드일 때는 아이콘을 흰색으로 변경합니다.
                        .padding(.top, -5)
                        .padding(.leading, -10)
                }
                .contentShape(Rectangle())
            )
        }
    }
}

#Preview {
    MainView()
}
