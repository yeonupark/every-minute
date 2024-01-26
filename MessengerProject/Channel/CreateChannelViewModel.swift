//
//  CreateChannelViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/26.
//

import Foundation
import Combine
import Moya

class CreateChannelViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var description = ""
    
    @Published var isNameFieldFilled = false
    
    init() {
        fieldCheck()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fieldCheck() {
        $name
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.isNameFieldFilled, on: self)
            .store(in: &cancellables)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func createChannel() {
        
    }
}
