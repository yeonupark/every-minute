//
//  SignUpViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/11.
//

import Combine
import Foundation
import Moya

class SignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var nickname = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
    @Published var deviceToken = ""
    
    @Published var isValidEmail = false
    @Published var isValidLoginForm = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //fieldCheck()
    }
    
    func fieldCheck() {
        
//        var isEmailValidPublisher: AnyPublisher<Bool, Never> {
//            $email
//                .map { email in
//                    print(email)
//                    return !email.isEmpty
//                }
//                .eraseToAnyPublisher()
//            
//        }
        
        var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
            Publishers.CombineLatest($password, $passwordRepeat)
                .map { (pw, pw2) in
                    return !pw.isEmpty && (pw == pw2)
                }
                .eraseToAnyPublisher()
        }
        
        Publishers.CombineLatest3($isValidEmail, $nickname, isPasswordValidPublisher)
            .map { emailValid, nickname, pwValid in
                if nickname.isEmpty { return false }
                return emailValid && pwValid
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.isValidLoginForm, on: self)
            .store(in: &cancellables)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func callEmailValidation(email: String, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.emailValidation(email: email)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("emailvalidation success - ", response.statusCode, response.data)
                    
                    completionHandler(true)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("emailvalidation failure - ", response.statusCode, response.data)
                    
                    completionHandler(false)
                
                }
            case .failure(let error):
                print("emailValidation Error - ", error)
                completionHandler(false)
            }
        }
        
    }
    
    func callJoinRequest(join: JoinModel) {
        provider.request(.join(join: join)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("join success - ", response.statusCode, response.data)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("join failure - ", response.statusCode, response.data)
                }
            case .failure(let error):
                print("join Error - ", error)
            }
        }
    }
}
