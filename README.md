# ImageUploader

A modern iOS application for uploading images with reference names, featuring gallery selection and camera capture capabilities. Images are stored in Cloudinary with metadata in Firebase Firestore.

![iOS](https://img.shields.io/badge/iOS-16.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.7-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

- 📸 **Image Capture**: Take photos directly using device camera
- 🖼️ **Gallery Selection**: Pick images from photo library
- 🔖 **Reference Naming**: Add descriptive names to your uploads
- 📊 **Image Management**: View all uploaded images in a dedicated tab
- ☁️ **Cloud Storage**: Images stored in Cloudinary
- 🔥 **Firebase Integration**: Metadata stored in Firestore
- 🚀 **Modern Architecture**: Built with SwiftUI and Combine

## 📱 Screenshots

<p float="left">
  <img width="342" alt="Image" src="https://github.com/user-attachments/assets/12c8f3af-4745-4a05-9e17-f62f63d181f5" />
  <img src="/api/placeholder/250/550" alt="Image Naming" width="250" />
  <img src="/api/placeholder/250/550" alt="Gallery View" width="250" />
</p>

## 🏗️ Architecture

The app follows a clean architecture approach with SwiftUI and Combine:

- **UI Layer**: SwiftUI views and components
- **Presentation Layer**: ViewModels using Combine
- **Domain Layer**: Use cases and business logic
- **Data Layer**: Repository implementations and API services

## 🔧 Technologies

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming
- **Cloudinary**: Cloud-based image storage and transformation
- **Firebase Firestore**: NoSQL database for storing image metadata
- **Swift Package Manager**: Dependency management

## 📋 Requirements

- iOS 16.0+
- Xcode 14+
- Swift 5.7+
- Cloudinary account
- Firebase project

## 🚀 Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ImageUploader.git
```

2. Set up your Cloudinary credentials:
   - Create a `CloudinaryConfig.swift` file with your API details
   - Add it to the `.gitignore` to keep credentials secure

3. Set up Firebase:
   - Download `GoogleService-Info.plist` from your Firebase project
   - Add it to your project root

4. Install dependencies:
```bash
cd ImageUploader
swift package update
```

5. Open the project in Xcode:
```bash
open ImageUploader.xcodeproj
```

## 🖥️ Usage

### Upload Images

1. Launch the app and navigate to the Upload tab
2. Choose between "Select from Gallery" or "Take Photo" options
3. After image selection/capture, you'll be directed to the naming screen
4. Enter a reference name for your image
5. Tap "Submit" to upload to Cloudinary and store metadata in Firebase

### View Gallery

1. Switch to the Gallery tab
2. View all uploaded images with their reference names
3. Images are fetched from Cloudinary with metadata from Firebase

## ⚙️ Configuration

### Cloudinary Setup

Add your Cloudinary credentials to `CloudinaryConfig.swift`:

```swift
struct CloudinaryConfig {
    static let cloudName = "your_cloud_name"
    static let apiKey = "your_api_key"
    static let apiSecret = "your_api_secret"
}
```

### Firebase Setup

1. Create a Firebase project at [firebase.google.com](https://firebase.google.com)
2. Add iOS app to your project and download the `GoogleService-Info.plist`
3. Enable Firestore in your Firebase project

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
