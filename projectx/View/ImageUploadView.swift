//
//  ImageUploadView.swift
//  projectx
//
//  Created by jeboy on 25/04/25.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct ImageUploadView: View {
    // MARK: - State Properties
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isShowingCamera = false
    @State private var navigateToSubmitView = false
    @State private var showCameraAlert = false
    @State private var cameraAlertMessage = ""
    
    // MARK: - Main View
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                // MARK: Gallery Picker Section
                galleryPickerSection
                
                // MARK: OR Divider
                orDivider
                
                // MARK: Camera Button
                cameraButton
                
                Spacer()
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isShowingCamera) {
                CameraView(selectedImage: $selectedImage, isShowingCamera: $isShowingCamera)
            }
            .onChange(of: selectedImage) { newImage in
                handleImageSelection(newImage)
            }
            .navigationDestination(isPresented: $navigateToSubmitView) {
                if let image = selectedImage {
                    ImageSubmitView(image: image)
                }
            }
            .alert("Camera Access Required",
                   isPresented: $showCameraAlert) {
                cameraAlertButtons
            } message: {
                Text(cameraAlertMessage)
            }
        }
    }
    
    // MARK: - View Components
    
    private var galleryPickerSection: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .frame(height: 150)
                
                PhotosPicker(selection: $photosPickerItem) {
                    VStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "photo")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        Text("Browse Gallery")
                            .font(.headline)
                    }
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: photosPickerItem) { newItem in
            loadTransferable(from: newItem)
        }
    }
    
    private var orDivider: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
            
            Text("OR")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
    
    private var cameraButton: some View {
        Button(action: checkCameraAvailability) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 1, dash: [6]))
                    .frame(height: 60)
                
                HStack {
                    Image(systemName: "camera")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                    
                    Text("Open Camera")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var cameraAlertButtons: some View {
        Group {
            Button("Cancel", role: .cancel) {}
            Button("Settings") {
                openAppSettings()
            }
        }
    }
    
    // MARK: - Action Methods
    
    private func handleImageSelection(_ image: UIImage?) {
        if image != nil {
            navigateToSubmitView = true
        }
    }
    
    private func loadTransferable(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let imageData):
                if let imageData, let uiImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        selectedImage = uiImage
                    }
                }
            case .failure(let error):
                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkCameraAvailability() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            handleAuthorizedCameraStatus()
        case .restricted, .denied:
            setCameraAccessDeniedMessage()
        case .notDetermined:
            requestCameraAccess()
        @unknown default:
            setUnknownCameraStateMessage()
        }
    }
    
    // MARK: - Camera Permission Helpers
    
    private func handleAuthorizedCameraStatus() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            isShowingCamera = true
        } else {
            setCameraNotAvailableMessage()
        }
    }
    
    private func setCameraAccessDeniedMessage() {
        cameraAlertMessage = "Camera access is required to take photos. Please enable camera access in Settings."
        showCameraAlert = true
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.handleAuthorizedCameraStatus()
                } else {
                    self.setCameraAccessDeniedMessage()
                }
            }
        }
    }
    
    private func setCameraNotAvailableMessage() {
        cameraAlertMessage = "Camera is not available on this device."
        showCameraAlert = true
    }
    
    private func setUnknownCameraStateMessage() {
        cameraAlertMessage = "Unknown camera state."
        showCameraAlert = true
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Camera View Representable
struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isShowingCamera: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.fixedOrientation()
            }
            parent.isShowingCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShowingCamera = false
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    func fixedOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

// MARK: - Preview
#Preview {
    ImageUploadView()
}
