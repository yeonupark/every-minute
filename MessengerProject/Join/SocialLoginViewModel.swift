//
//  SocialLoginViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/02/05.
//

import Foundation
import Moya

class SocialLoginViewModel: ObservableObject {
    
    private let provider = MoyaProvider<MarAPI>()
    
    func kakaoLogin(token: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.kakaoLogin(model: KakaoLoginModel(oauthToken: token, deviceToken: UserDefaults.standard.string(forKey: "deviceToken") ?? ""))) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("kakao login success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(JoinResponse.self, from: response.data)
                        print(result)
                        UserDefaults.standard.set(result.token?.accessToken, forKey: "token")
                        UserDefaults.standard.set(result.token?.refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(result.nickname, forKey: "nickname")
                        UserDefaults.standard.set(result.user_id, forKey: "id")
                        completionHandler(true)
                    } catch {
                        print("kakao login decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("kakao login failure - ", response.statusCode, response.data)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("kakao login Error - ", error)
                completionHandler(false)
            }
        }
    }
    
    func appleLogin(token: String, nickname: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.appleLogin(model: AppleLoginModel(idToken: token, nickname: nickname, deviceToken: UserDefaults.standard.string(forKey: "deviceToken") ?? ""))) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("apple login success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(JoinResponse.self, from: response.data)
                        print(result)
                        UserDefaults.standard.set(result.token?.accessToken, forKey: "token")
                        UserDefaults.standard.set(result.token?.refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(result.nickname, forKey: "nickname")
                        UserDefaults.standard.set(result.user_id, forKey: "id")
                        completionHandler(true)
                    } catch {
                        print("apple login decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("apple login failure - ", response.statusCode, response.data)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("apple login Error - ", error)
                completionHandler(false)
            }
        }
    }
}
