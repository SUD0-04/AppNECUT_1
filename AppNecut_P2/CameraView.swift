//
//  CameraView.swift
//  AppNecut_P2
//
//  Created by Kngmin Kang on 12/22/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var shotCount = 4
    @State private var cameraPosition = AVCaptureDevice.Position.back
    private let cameraController = CameraController()

    var body: some View {
        VStack {
            ZStack {
                CameraPreview(cameraController: cameraController)
                image?
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            HStack { // HStack을 사용하여 버튼을 수평으로 배열합니다.
                Button(action: {
                    if self.shotCount > 0 {
                        // Add your code to take a photo here
                        self.shotCount -= 1
                    }
                }) {
                    Text("\(shotCount)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(Color.black)
                        .clipShape(Circle())
                        .padding(.leading, 90)
                }
                .padding()
                .disabled(shotCount <= 0)
                
                Button(action: {
                    switch cameraPosition {
                    case .front:
                        self.cameraPosition = AVCaptureDevice.Position.back
                        self.cameraController.cameraPosition = AVCaptureDevice.Position.back
                    case .back:
                        self.cameraPosition = AVCaptureDevice.Position.front
                        self.cameraController.cameraPosition = AVCaptureDevice.Position.front
                    default:
                        self.cameraPosition = AVCaptureDevice.Position.back
                        self.cameraController.cameraPosition = AVCaptureDevice.Position.back
                    }
                    do {
                        self.cameraController.stopSession()
                        try self.cameraController.startSession()
                    } catch {
                        print(error)
                    }
                }) {
                    Text(cameraPosition == .front ? "앞" : "뒤")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
            }
        }
        .onAppear {
            do {
                try self.cameraController.startSession()
            } catch {
                print(error)
            }
        }
        .onDisappear {
            self.cameraController.stopSession()
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage, cameraPosition: self.$cameraPosition)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        if shotCount > 0 {
            shotCount -= 1
        }
    }
}

struct CameraPreview: UIViewControllerRepresentable {
    let cameraController: CameraController

    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        cameraController.previewLayer.frame = viewController.view.bounds
        viewController.view.layer.addSublayer(cameraController.previewLayer)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        cameraController.previewLayer.frame = uiViewController.view.bounds
    }
}

class CameraController: NSObject {
    let captureSession = AVCaptureSession()
    let previewLayer = AVCaptureVideoPreviewLayer()
    var cameraPosition: AVCaptureDevice.Position = .back

    override init() {
        super.init()

        if let camera = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print(error)
            }

            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }

            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
        }
    }

    func startSession() throws {
        DispatchQueue.global().async {
            if !self.captureSession.isRunning {
                if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: self.cameraPosition) {
                    do {
                        // Remove the existing inputs
                        let inputs = self.captureSession.inputs
                        for oldInput in inputs {
                            self.captureSession.removeInput(oldInput)
                        }

                        let input = try AVCaptureDeviceInput(device: camera)
                        if self.captureSession.canAddInput(input) {
                            self.captureSession.addInput(input)
                        }

                        self.captureSession.startRunning()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var cameraPosition: AVCaptureDevice.Position

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraDevice = cameraPosition == .front ? .front : .rear
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            picker.dismiss(animated: true)
        }
    }
}

#Preview {
    CameraView()
}
