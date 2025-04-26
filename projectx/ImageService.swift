//
//  ImageService.swift
//  projectx
//
//  Created by jeboy on 26/04/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Cloudinary

class ImageService: ObservableObject {
    @Published var images: [ImageReference] = []
    private let db = Firestore.firestore()
    private let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: CloudinaryConfig.cloudName, secure: true))
    
    init() {
        fetchImages()
    }
    
    func uploadImage(image: UIImage, referenceName: String, completion: @escaping (Bool, String?) -> Void) {
        // First upload to Cloudinary
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            completion(false, "Could not prepare image data")
            return
        }
        
        // Create upload params
        let params = CLDUploadRequestParams()
        params.setResourceType(.image)
        
        // Upload to Cloudinary
        cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinaryConfig.uploadPreset, params: params, progress: nil) { (result, error) in
            if let error = error {
                print("Cloudinary upload error: \(error)")
                completion(false, error.localizedDescription)
                return
            }
            
            guard let result = result, let secureUrl = result.secureUrl else {
                completion(false, "No secure URL returned")
                return
            }
            
            // Now add to Firestore
            let imageRef = ImageReference(
                id: UUID().uuidString,
                referenceName: referenceName,
                imageUrl: secureUrl,
                timestamp: Date()
            )
            
            self.db.collection("images").document(imageRef.id).setData([
                "id": imageRef.id,
                "referenceName": imageRef.referenceName,
                "imageUrl": imageRef.imageUrl,
                "timestamp": Timestamp(date: imageRef.timestamp)
            ]) { error in
                if let error = error {
                    print("Firestore error: \(error)")
                    completion(false, error.localizedDescription)
                } else {
                    // Add to local array for immediate UI update
                    DispatchQueue.main.async {
                        self.images.append(imageRef)
                        self.images.sort { $0.timestamp > $1.timestamp }
                        completion(true, nil)
                    }
                }
            }
        }
    }
    
    func fetchImages() {
        db.collection("images").order(by: "timestamp", descending: true).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching images: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.images = documents.compactMap { document -> ImageReference? in
                let data = document.data()
                
                guard let id = data["id"] as? String,
                      let referenceName = data["referenceName"] as? String,
                      let imageUrl = data["imageUrl"] as? String,
                      let timestamp = data["timestamp"] as? Timestamp else {
                    return nil
                }
                
                return ImageReference(
                    id: id,
                    referenceName: referenceName,
                    imageUrl: imageUrl,
                    timestamp: timestamp.dateValue()
                )
            }
        }
    }
}
