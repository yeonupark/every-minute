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
    @Published var currentWorkspace = OneWorkspaceData(workspaceID: 0, description: nil, name: "", thumbnail: "", ownerID: 0, createdAt: "", channels: [], workspaceMembers: [])
    
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
                        
                        self.isEmptyView = result.isEmpty
                        self.workspaces = result
                        self.isLogout = false
                        
                        if !result.isEmpty {
                            self.fetchOneWorkspace(id: result[0].id)
                        }
                        
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
    
    func fetchOneWorkspace(id: Int) {
        provider.request(.getOneWorkspace(id: id)) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    do {
                        let data = try JSONDecoder().decode(OneWorkspaceData.self, from: response.data)
                        print("fetch one workspace success")
                        print(data)
                        self.currentWorkspace = data
                    } catch {
                        print("fetch one workspace decoding error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("fetch one workspace failure - ", response.statusCode, response.data)
                    
                }
            case .failure(let error):
                print("fetch one workspace Error - ", error)
            }
        }
    }
    
    func tokenRefresh() {
        
        provider.request(.tokenRefresh) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("refresh token success - ", response.statusCode, response.data)
                    
                    do {
                        let result = try JSONDecoder().decode(RefreshTokenResponse.self, from: response.data)
                        print("액세스 토큰 갱신")
                        UserDefaults.standard.set(result.accessToken, forKey: "token")
                        self.isLogout = false
                        
                    } catch {
                        print("refresh token decoding error")
                    }
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("refresh token failure - ", response.statusCode, response.data)
                }
            case .failure(let error):
                print("refresh token Error - ", error)
            }
        
        }
    }
    
    func saveDeviceToken() {
        let token = UserDefaults.standard.string(forKey: "deviceToken")
        
        let provider = MoyaProvider<MarAPI>()
        
        provider.request(.deviceToken(deviceToken: token ?? "")) { result in
            switch result {
            case .success(let response):
                if (200..<300).contains(response.statusCode) {
                    print("하하하하 deviceToken success - ", response.statusCode, response.data)
                    
                } else if (400..<501).contains(response.statusCode) {
                    print("deviceToken failure - ", response.statusCode, response.data)
                    
                }
            case .failure(let error):
                print("deviceToken Error - ", error)
            }
        }
    }
}
