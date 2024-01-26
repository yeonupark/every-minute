//
//  LoginViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/14.
//

import Foundation
import Combine
import Moya

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoginAvailable = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fieldCheck()
    }
    
    func fieldCheck() {
        Publishers.CombineLatest($email, $password)
            .map({ email, pw in
                return !email.isEmpty && !pw.isEmpty
            })
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.isLoginAvailable, on: self)
            .store(in: &cancellables)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func callLoginRequest(completionHandler: @escaping (Bool) -> Void) {
        
        let model = LoginModel(email: email, password: password, deviceToken: UserDefaults.standard.string(forKey: "deviceToken"))
        
        provider.request(.login(login: model)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("login success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(LoginResponse.self, from: response.data)
                        print(result)
                        UserDefaults.standard.set(result.accessToken, forKey: "token")
                        UserDefaults.standard.set(result.refreshToken, forKey: "refreshToken")
                        UserDefaults.standard.set(result.nickname, forKey: "nickname")
                        UserDefaults.standard.set(result.user_id, forKey: "id")
                        completionHandler(true)
                    } catch {
                        print("login decoding error")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("login failure - ", response.statusCode, response.data)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("login Error - ", error)
                completionHandler(false)
            }
        }
    }
}
