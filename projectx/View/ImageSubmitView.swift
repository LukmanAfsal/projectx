//
//  ImageSubmitView.swift
//  projectx
//
//  Created by jeboy on 25/04/25.
//

import SwiftUI

struct ImageSubmitView: View {
    // MARK: - Properties
    let image: UIImage
    @State private var referenceName = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var imageService: ImageService
    @State private var isUploading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var uploadSuccess = false
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Main View
    var body: some View {
        VStack {
            imageDisplaySection
            
            referenceNameField
            
            submitButton
            
            Spacer()
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            uploadResultAlert
        }
    }
    
    // MARK: - View Components
    private var imageDisplaySection: some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
            
            Button(action: dismissView) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .padding(8)
                    .background(Circle().fill(Color.red))
            }
            .padding(12)
        }
    }
    
    private var referenceNameField: some View {
        TextField("Reference Name", text: $referenceName)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            .padding(.top)
            .disabled(isUploading)
    }
    
    private var submitButton: some View {
        Button(action: uploadImage) {
            if isUploading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Submit")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .frame(width: 200)
            }
        }
        .background(isUploading ? Color.gray : Color.green)
        .cornerRadius(10)
        .disabled(isUploading || referenceName.isEmpty)
        .padding(.top, 20)
    }
    
    private var uploadResultAlert: Alert {
        Alert(
            title: Text(uploadSuccess ? "Success" : "Error"),
            message: Text(alertMessage),
            dismissButton: .default(Text("OK")) {
                if uploadSuccess {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
    }
    
    // MARK: - Actions
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func uploadImage() {
        isUploading = true
        
        imageService.uploadImage(image: image, referenceName: referenceName) { success, errorMessage in
            isUploading = false
            uploadSuccess = success
            alertMessage = success ? "Image uploaded successfully!" : "Upload failed: \(errorMessage ?? "Unknown error")"
            showAlert = true
        }
    }
}

// MARK: - Preview
#Preview {
    ImageSubmitView(image: UIImage(systemName: "photo")!)
        .environmentObject(ImageService())
}
