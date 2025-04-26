//
//  projectxApp.swift
//  projectx
//
//  Created by jeboy on 25/04/25.
//

import SwiftUI
import FirebaseCore

@main
struct ProjectXApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var imageService = ImageService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(imageService)
        }
    }
}
