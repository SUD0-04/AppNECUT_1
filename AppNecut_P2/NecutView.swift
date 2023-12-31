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
    
    var body: some View {
        VStack {
            if let combinedImage = combinedImage {
                Image(uiImage: combinedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Button("Save Image") {
                    guard let combinedImage = self.combinedImage else { return }
                    UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
                }
            } else {
                Text("Combining Images...")
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


#Preview {
    Necut()
}
