//
//  MyProfileViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/23.
//

import Foundation
import Moya

class MyProfileViewModel {
    
    private let provider = MoyaProvider<MarAPI>()
    
    func callLogout(completionHandler: @escaping (Bool) -> Void) {
        
        provider.request(.logout) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("logout success - ", response.statusCode, response.data)
                    UserDefaults.standard.removeObject(forKey: "token")
                    UserDefaults.standard.removeObject(forKey: "refreshToken")
                    UserDefaults.standard.removeObject(forKey: "nickname")
                    
                    completionHandler(true)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("logout failure - ", response.statusCode, response.data)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("logout Error - ", error)
                completionHandler(false)
            }
        }
    }
}
