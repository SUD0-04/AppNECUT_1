//
//  Necut.swift
//  AppNecut_P2
//
//  Created by Kngmin Kang on 12/31/23.
//

import SwiftUI

struct NecutView: View {
    var images: [UIImage]
    @State private var combinedImage: UIImage?
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if let combinedImage = combinedImage {
                Image(uiImage: combinedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Button(action: {
                    guard let combinedImage = self.combinedImage else { return }
                    UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
                }) {
                    Text("SAVE")
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .font(.system(size: 13, weight: .bold))
                        .padding()
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("OH, NO! 😭"), message: Text("BACK TO HOME."), dismissButton: .default(Text("HOME")){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                }
            } else {
                Text("Combining...")
                    .onAppear {
                        self.combineImages()
                    }
            }
        }
    }
    
    func combineImages() {
            let size = CGSize(width: images[0].size.width * 2, height: images[0].size.height * 2)
            UIGraphicsBeginImageContext(size)
            
            for i in 0..<2 {
                for j in 0..<2 {
                    images[i * 2 + j].draw(in: CGRect(x: size.width / 2 * CGFloat(j),
                                                      y: size.height / 2 * CGFloat(i),
                                                      width: size.width / 2, height: size.height / 2))
                }
            }
            
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self.combinedImage = combinedImage
        }
}


// Preview 기능
struct NecutView_Previews: PreviewProvider {
    static var previews: some View {
        // 임의의 이미지 생성
        let image = UIImage(systemName: "photo") ?? UIImage()
        // 임의의 이미지 4개를 전달하여 NecutView 생성
        NecutView(images: [image, image, image, image])
    }
}
