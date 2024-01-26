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
    
    @Published var newChannel = Channel(workspaceID: 0, channelID: 0, name: "", description: nil, ownerID: 0, channelPrivate: 0, createdAt: "")
    
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
    
    func createChannel(workspaceID: Int, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.createChannel(id: workspaceID, model: NewChannelModel(name: name, description: description))) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(Channel.self, from: response.data)
                        print("create success - ", response.statusCode, response.data)
                        self.newChannel = result
                        completionHandler(true)
                    } catch {
                        print("create decoding error - ")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("create failure - ", response.statusCode)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("create Error - ", error)
                completionHandler(false)
            }
        }
    }
}
