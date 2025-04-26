//
//  ContentView.swift
//  projectx
//
//  Created by jeboy on 25/04/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var imageService = ImageService()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ImageUploadView()
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Upload")
                    }
                }
                .tag(0)
            
            ImagesView()
                .tabItem {
                    VStack {
                        Image(systemName: "person.circle")
                        Text("Images")
                    }
                }
                .tag(1)
        }
        .accentColor(.green)
        .environmentObject(imageService)
        .onReceive(imageService.$images) { _ in
            // Automatically switch to Images tab when new image is added
            if !imageService.images.isEmpty {
                selectedTab = 1
            }
        }
    }
}
#Preview {
    ContentView()
}
