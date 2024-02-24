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
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("==== APNS 토큰 설정됨 ====")
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
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
        
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//              print("호호호")
//            //self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//            //UserDefaults.standard.set(token, forKey: "deviceToken")
//          }
//        }
        UNUserNotificationCenter.current().delegate = self
        
        return true
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
        //print("토큰 받음 - Firebase registration token: \(String(describing: fcmToken))")
        
        print("==== fcm 토큰 설정됨 ====")
        UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
    }
    
}
