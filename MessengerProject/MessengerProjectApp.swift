//
//  MessengerProjectApp.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/06.
//

import SwiftUI
import Kingfisher
import RealmSwift
import KakaoSDKCommon
import KakaoSDKAuth
import Moya
import FirebaseCore
import FirebaseMessaging

@main
struct MessengerProjectApp: SwiftUI.App {
    
    init() {
        configureRealm()
        saveDeviceToken()
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .onAppear() {
                    print("accessToken: \(UserDefaults.standard.string(forKey: "token") ?? "")")
                }
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }

    func configureRealm() {
        let config = Realm.Configuration(schemaVersion: 11) { migration, oldSchemaVersion in
            
            if oldSchemaVersion < 1 { } // UserTable에 id 추가
            
        }
        Realm.Configuration.defaultConfiguration = config
    }
    
    func saveDeviceToken() {
        let token = UserDefaults.standard.string(forKey: "deviceToken")
        
        let provider = MoyaProvider<MarAPI>()
        
        provider.request(.deviceToken(deviceToken: token ?? "")) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("하하하하 devideToken success - ", response.statusCode, response.data)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("devideToken failure - ", response.statusCode, response.data)
                    
                }
            case .failure(let error):
                print("devideToken Error - ", error)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(APIkeys.sesacKey, forHTTPHeaderField: "SesacKey")
            r.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "Authorization")
            return r
        }
        
        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]
        
        KakaoSDK.initSDK(appKey: "07d0be2dced3c3a66c377d32b96f81de")
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
                
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//            //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
          
        let userInfo = notification.request.content.userInfo

        print(userInfo)

        completionHandler([[.banner, .badge, .sound]])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        print(userInfo)

        completionHandler()
      }

}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("토큰 받음 - Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        print(dataDict)
    }
    
}
