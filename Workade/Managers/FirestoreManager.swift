//
//  FirestoreManager.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/26.
//

import FirebaseFirestore
import Foundation

class FirestoreDAO {
    private init() { }
    static let shared = FirestoreDAO()
    private let dto = FirestoreDTO()
    
    private let activeUserCollectionName = "ActiveUser"
    private let allUserCollectionName = "AllUser"
    
    func getUsers() async throws -> [User] {
        let documents = try await dto.getDocuments(collectionName: allUserCollectionName)
        let decoder = JSONDecoder()
        var users = [User]()
        
        for document in documents {
            let data = document.data()
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let user = try decoder.decode(User.self, from: jsonData)
            users.append(user)
        }
        
        return users
    }
    
    func createUser(user: User) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.createDocument(collectionName: allUserCollectionName, documentName: user.id, data: data)
        UserManager.shared.user.value = user
    }
    
    func updateUser(user: User) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.updateDocument(collectionName: allUserCollectionName, documentName: user.id, data: data)
    }
    
    func deleteUser(userid: String) async throws {
        try await dto.deleteDocument(collectionName: allUserCollectionName, documentName: userid)
        UserManager.shared.user.value = nil
    }
    
    func getUser(userID: String) async throws -> User? {
        let documents = try await dto.getDocuments(collectionName: allUserCollectionName)
        let decoder = JSONDecoder()
        
        for document in documents {
            let data = document.data()
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let user = try decoder.decode(User.self, from: jsonData)
            UserManager.shared.user.value = user
            if user.id == userID {
                return user
            }
        }
        return nil
    }
    
    func createActiveUser(user: ActiveUser) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.createDocument(collectionName: user.region.rawValue, documentName: user.id, data: data)
        UserManager.shared.isActive = true
        UserManager.shared.activeRegion = user.region
        UserManager.shared.activeMyInfo = user
    }
    
    func deleteActiveUser(userID: String, region: Region) async throws {
        try await dto.deleteDocument(collectionName: region.rawValue, documentName: userID)
        UserManager.shared.activeRegion = nil
        UserManager.shared.activeMyInfo = nil
        UserManager.shared.isActive = false
    }
    
    func getActiveUsersNumber(region: Region) async throws -> Int {
        try await dto.getDocuments(collectionName: region.rawValue).count
    }
    
    func getActiveUsers(region: Region) async throws -> [Job: [ActiveUser]]? {
        let documents = try await dto.getDocuments(collectionName: region.rawValue)
        let decoder = JSONDecoder()
        var users = [Job: [ActiveUser]]()
        for job in Job.allCases {
            users[job] = []
        }
        
        for document in documents {
            let data = document.data()
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let activeUser = try decoder.decode(ActiveUser.self, from: jsonData)
            users[activeUser.job]?.append(activeUser)
        }
        return users
    }
    
    func setRegionListener(region: Region, listenerAction: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return dto.setListener(collectionName: region.rawValue, listenderAction: listenerAction)
    }
}

class FirestoreDTO {
    fileprivate init() { }
    
    private let database = Firestore.firestore()
    
    func createDocument(collectionName: String, documentName: String, data: [String: Any]) async throws {
        try await database.collection(collectionName).document(documentName).setData(data)
    }
    
    func updateDocument(collectionName: String, documentName: String, data: [String: Any]) async throws {
        try await database.collection(collectionName).document(documentName).updateData(data)
    }
    
    func deleteDocument(collectionName: String, documentName: String) async throws {
        try await database.collection(collectionName).document(documentName).delete()
    }
    
    func getDocuments(collectionName: String) async throws -> [QueryDocumentSnapshot] {
        return try await database.collection(collectionName).getDocuments().documents
    }
    
    func setListener(collectionName: String, listenderAction: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return database.collection(collectionName).addSnapshotListener(listenderAction)
    }
}
