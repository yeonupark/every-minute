//
//  CreateWorkspaceViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/18.
//

import Foundation
import Combine
import Moya

class CreateWorkspaceViewModel: ObservableObject {
    
    @Published var image = Image(resource: .chatIcon)
    
    @Published var name = ""
    @Published var description = ""
    //@Published var imageData = Data()
    @Published var imageString = ""
    
    @Published var isNameFieldFilled = false
    
    init() {
        fieldCheck()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func fieldCheck() {
        $name
            .map( { !$0.isEmpty } )
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.isNameFieldFilled, on: self)
            .store(in: &cancellables)
    }
    
    private let provider = MoyaProvider<MarAPI>()
    
    func createWorkspace(completionHandler: @escaping (Bool) -> Void) {
        let model = NewWorkspacesModel(name: name, description: description, image: imageString)
        provider.request(.createWorkspaces(model: model)) { result in
            
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let result = try JSONDecoder().decode(NewWorkspacesResponse.self, from: response.data)
                        print(result)
                        print("create success - ", response.statusCode, response.data)
                        completionHandler(true)
                    } catch {
                        print("create decoding error - ")
                        completionHandler(false)
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorMessage.self, from: response.data)
                        print("create failure - ", response.statusCode, errorResponse.errorCode)
                        completionHandler(false)
                    } catch {
                        print("create decoding error - ")
                        completionHandler(false)
                    }
                }
            case .failure(let error):
                print("create Error - ", error)
                completionHandler(false)
            }
        }
    }
}

struct ErrorMessage: Codable {
    let errorCode: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode
    }
}
