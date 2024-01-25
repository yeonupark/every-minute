//
//  HomeViewModel.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/17.
//

import Foundation
import Combine
import Moya

class HomeViewModel: ObservableObject {
    
    @Published var isEmptyView = true
    @Published var isLogout = true
    
    @Published var workspaces: [WorkspacesResponseData] = []
    @Published var currentWorkspace: WorkspacesResponseData = WorkspacesResponseData(workspace_id: 0, name: "", description: nil, thumbnail: "", owner_id: 0, createdAt: "")
    
    init() {
        fetchWorkspaces()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let provider = MoyaProvider<MarAPI>()
    
    func fetchWorkspaces() {
        
        provider.request(.getWorkspaces) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    
                    do {
                        let result = try JSONDecoder().decode([WorkspacesResponseData].self, from: response.data)
                        print(result)
                        
                        self.isEmptyView = result.isEmpty
                        self.workspaces = result
                        self.isLogout = false
                        
                        self.currentWorkspace = result[0]
                        
                    } catch {
                        print("fetchWorkspaces decoding error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("fetchWorkspaces failure - ", response.statusCode, response.data)
                                    
                }
            case .failure(let error):
                print("fetchWorkspaces Error - ", error)
            }
        }
    }
    
    func makeURL(thumbnail: String) -> String {
        return "\(APIkeys.baseURL)v1\(thumbnail)"
    }
    
    func deleteWorkspace(id: Int, completionHandler: @escaping (Bool) -> Void) {
        provider.request(.deleteWorkspace(id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("delete success - ", response.statusCode, response.data)
                    
                    completionHandler(true)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("delete failure - ", response.statusCode, response.data)
                    completionHandler(false)
                    
                }
            case .failure(let error):
                print("delete Error - ", error)
                completionHandler(false)
            }
        }
    }
}
