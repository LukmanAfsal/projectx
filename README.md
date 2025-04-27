📷 Image Uploader App
A modern iOS application for uploading images with reference names, featuring gallery selection and camera capture capabilities, built using SwiftUI and Combine.

✨ Features
📸 Image Capture: Take photos directly using the device camera.

🖼️ Gallery Selection: Pick images from the device photo library.

🔖 Reference Naming: Add a custom name for each uploaded image.

☁️ Cloud Upload: Upload images securely to Cloudinary.

🔥 Data Storage: Save image URLs and reference names in Firebase Firestore.

🖼️ Image Gallery: View all uploaded images with their names in a dedicated tab.

🚀 Modern Architecture: Built with SwiftUI, Combine, and MVVM principles.

📱 App Flow
Upload Tab:

Choose to either browse a photo from the gallery or capture a new one using the camera.

After selecting or capturing an image, you're directed to the Image Submit View.

Enter a name for your image and submit.

Uploading Process:

The image is first uploaded to Cloudinary.

After successful upload, the image URL and reference name are stored in Firebase Firestore.

Images Tab:

Automatically fetches and displays all uploaded images along with their names.

Real-time updates ensure the gallery view stays current.

📸 Screenshots



🛠️ Requirements
iOS 16.0+

Xcode 14+

Swift 5.7+

🧰 Technologies Used
SwiftUI — declarative UI framework

Combine — reactive programming framework

Cloudinary — image hosting and management

Firebase Firestore — cloud NoSQL database

Firebase SDK — authentication and database integration

🚀 Installation
Clone the repository:

bash
Copy
Edit
git clone https://github.com/yourusername/projectx.git
