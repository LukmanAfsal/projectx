//
//  ImagesView.swift
//  projectx
//
//  Created by jeboy on 25/04/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImagesView: View {
    @EnvironmentObject private var imageService: ImageService
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if imageService.images.isEmpty {
                    // Your empty state view remains the same
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(imageService.images) { imageRef in
                            VStack(alignment: .leading, spacing: 8) {
                                WebImage(url: URL(string: imageRef.imageUrl))
                                    .resizable()
                                    .indicator(.activity)
                                    .transition(.fade(duration: 0.5))
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 160) // Fixed height for all images
                                    .clipped()
                                    .cornerRadius(12)
                                
                                Text(imageRef.referenceName)
                                    .font(.system(size: 14))
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .onAppear {
                imageService.fetchImages()
            }
        }
    }
}


#Preview {
    ImagesView()
}
