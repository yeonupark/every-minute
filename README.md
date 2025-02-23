# 🕰️ Everyminute

### 📱 App Overview
Everyminute is a team collaboration application that helps members working towards common tasks communicate. 

---
### 📸 Screenshots
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/a6f1aec5-9393-48ad-aa5e-93feaa704565" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/96726cf2-e806-4d5d-9dd2-9e20f2a9acc6" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/0f608100-d886-4632-af52-084461b815a6" width="23%" height="23%">
<img src = "https://github.com/yeonupark/ShoppingProject/assets/130972950/ed388979-ac5f-4e11-94d6-1c984b63397e" width="23%" height="23%">

---
### ⚙️ System Requirements
- Xcode Version: 15.0
- macOS Version: Ventura 13.5 (M2)

### 🔧 Project Requirements
- Swift Version: 5.9
- iOS Deployment Target: 16.4 or later
- Dependencies: Moya, Socket.iO, RealmSwift, Kakao-iOS-SDK, Firebase-iOS-SDK, SnapKit, Kingfisher

---
### ⚙️ Installation

1️⃣ **Clone the repository**
```
git clone https://github.com/yeonupark/every-minute
```
2️⃣ **Open the project**
```
cd every-minute
xed .
``` 

▶️ **Running the App**

1. Open the project in Xcode

2. Select a simulator or physical device

3. Press Cmd + R to run the app

---
### 🔧 Tech Stack & Libraries

- SwiftUI, PhotosUI
- Combine
- AuthenticationServices
- MVVM
- Moya
- Kingfisher
- Socket.IO-Client-Swift
- RealmSwift
- Kakao-iOS-SDK
- Firebase-iOS-SDK
- APNs, Firebase Cloud Messaging

---
### ✔ Key Features

⚡ **Reactive UI with SwiftUI & Combine**
- Handles asynchronous tasks and UI updates efficiently using @State and @Binding.

📂 **Gesture-Based User Interaction**
- Implements DragGesture to enhance the user experience with intuitive interactions.

💬 **Real-Time Chat System**
- Stores chat messages in RealmDB, ensuring efficient data management.
- Uses SocketIO to deliver new messages in real-time to team members.

🔔 **Push Notifications with FCM & APNs**
- Sends real-time push notifications for new chat messages.

🔑 **Secure Authentication**
- Implements Apple Login (AuthenticationServices) and Kakao Login (KakaoSDKUser) for seamless user authentication.
  
---
