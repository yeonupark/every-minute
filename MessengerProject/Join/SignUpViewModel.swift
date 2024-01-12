//
//  SignUpViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/11.
//

import Combine
import Foundation

class SignUpViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var nickname = ""
    @Published var phoneNumber = ""
    @Published var password = ""
    @Published var passwordRepeat = ""
    @Published var deviceToken = ""
    
    @Published var isValidLoginForm = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        //fieldCheck()
    }
    
    func fieldCheck() {
        
        var isEmailValidPublisher: AnyPublisher<Bool, Never> {
            $email
                .map { email in
                    print(email)
                    return !email.isEmpty
                }
                .eraseToAnyPublisher()
            
        }
        
        var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
            Publishers.CombineLatest3($nickname, $password, $passwordRepeat)
                .map { (nick, pw, pw2) in
                    return (pw == pw2) && !nick.isEmpty && !pw.isEmpty
                }
                .eraseToAnyPublisher()
        }
        
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
            .map { emailValid, pwValid in
                return emailValid && pwValid
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.isValidLoginForm, on: self)
            .store(in: &cancellables)
    }
}
