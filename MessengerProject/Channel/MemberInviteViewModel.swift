//
//  MemberInviteViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/26.
//

import Foundation
import Combine
import Moya

class MemberInviteViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var idEmailFieldFilled = false
    
    init() {
        fieldCheck()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fieldCheck() {
        $email
            .map { email in
                !email.isEmpty
            }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.idEmailFieldFilled, on: self)
            .store(in: &cancellables)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func inviteMember(id: Int, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.inviteMember(id: id, email: email)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(WorkspaceMember.self, from: response.data)
                        print("invite success - ", response.statusCode, response.data)
                        //self.newChannel = result
                        completionHandler(true)
                    } catch {
                        print("invite decoding error - ")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("invite failure - ", response.statusCode)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("invite Error - ", error)
                completionHandler(false)
                
            }
        }
    }
}
