//
//  SignUpViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/11.
//

import Combine
import SwiftUI

class SignUpViewModel: ObservableObject {
    
    var email = CurrentValueSubject<String, Error>("")
    var nickname = CurrentValueSubject<String, Error>("")
    var phoneNumber = CurrentValueSubject<String, Error>("")
    var password = CurrentValueSubject<String, Error>("")
    var passwordRepeat = CurrentValueSubject<String, Error>("")
    var deviceToken = CurrentValueSubject<String, Error>("")
    
    var signUpButtonImage = CurrentValueSubject<Image, Error>(Image(.joinButton))
    
    init() {
        fieldCheck()
    }
    
    func fieldCheck() {
        
        var cancellables: Set<AnyCancellable> = []
        
        var validation: AnyPublisher<Bool, Error> {
                return Publishers.CombineLatest4(email, nickname, password, passwordRepeat)
                    .map { email, nick, pw, pw2 in
                        if email.isEmpty || nick.isEmpty || (pw != pw2) {
                            return false
                        }
                        return true
                    }
                    .eraseToAnyPublisher()
            }

        validation
                .map { isValid in
                    isValid ? Image(.joinButtonEnabled) : Image(.joinButton)
                }
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                        // 에러 처리를 추가할 수 있음
                        // completion에는 성공 또는 에러가 포함됨
                    }, receiveValue: { [weak self] image in
                        self?.signUpButtonImage.send(image)
                    })
                .store(in: &cancellables)
        
    }
}
