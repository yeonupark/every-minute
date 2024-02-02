//
//  ChatTableRepository.swift
//  MessengerProject
//
//  Created by Yeonu Park on 2024/01/30.
//

import Foundation
import RealmSwift

protocol ChatTableRepositoryType: AnyObject {
    
    func fetch(channelName: String) -> Results<ChatTable>
    func addItem(item: ChatTable)
}

class ChatTableRepository: ChatTableRepositoryType {
    
    private let realm = try! Realm()
    
    func printRealmLocation() {
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func checkSchemaVersion() {
        do {
            let version = try schemaVersionAtURL(realm.configuration.fileURL!)
            print("Schema Version: \(version)")
        } catch {
            print(error)
        }
    }
    
    func fetch(channelName: String) -> RealmSwift.Results<ChatTable> {
        
        let data = realm.objects(ChatTable.self).filter("channelName == '\(channelName)'")
        return data
    }
    
    func addItem(item: ChatTable) {
        do {
            try realm.write {
                realm.add(item)
            }
        }
        catch {
            print(error)
        }
    }
    
}
