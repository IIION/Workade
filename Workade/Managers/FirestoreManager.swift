//
//  FirestoreManager.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/26.
//

import FirebaseFirestore
import Foundation

class FirestoreDAO {
    private init() {
        for region in Region.allCases {
            
            regionListener[region] = setRegionListener(region: region)
        }
    }
    
    static let shared = FirestoreDAO()
    private let dto = FirestoreDTO()
    
    private let activeUserCollectionName = "ActiveUser"
    private let allUserCollectionName = "AllUser"
    private var regionListener = [Region: ListenerRegistration]()
    
    func createUser(user: User) async throws {
        guard let data = user.asDictionary else { return }
        do {
            try await dto.createDocument(collectionName: allUserCollectionName, documentName: user.id, data: data)
        } catch {
            print("LOG", error.localizedDescription)
        }
        UserManager.shared.user.value = user
    }
    
    func updateUser(user: User) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.updateDocument(collectionName: allUserCollectionName, documentName: user.id, data: data)
        UserManager.shared.user.value = user
    }
    
    func deleteUser(userid: String) async throws {
        try await dto.deleteDocument(collectionName: allUserCollectionName, documentName: userid)
        UserManager.shared.user.value = nil
    }
    
    func getUser(userID: String) async throws -> User? {
        let document = try await dto.getDocument(collectionName: allUserCollectionName, documentName: userID)
        let decoder = JSONDecoder()
        
        let data = document.data()
        guard let data = data else { return nil }
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let user = try decoder.decode(User.self, from: jsonData)
        UserManager.shared.user.value = user
        
        return nil
}
    
    func createActiveUser(user: ActiveUser) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.createDocument(collectionName: user.region.rawValue, documentName: user.id, data: data)
        UserManager.shared.activeMyInfo = user
    }
    
    func updateActiveUser(user: ActiveUser) async throws {
        guard let data = user.asDictionary else { return }
        try await dto.updateDocument(collectionName: user.region.rawValue, documentName: user.id, data: data)
        UserManager.shared.activeMyInfo = user
    }
    
    func deleteActiveUser(userID: String, region: Region) async throws {
        try await dto.deleteDocument(collectionName: region.rawValue, documentName: userID)
        UserManager.shared.activeMyInfo = nil
    }
    
    func getActiveUsersNumber(region: Region) async throws -> Int {
        try await dto.getDocuments(collectionName: region.rawValue).count
    }
    
    func getActiveUser(region: Region, uid: String) async throws {
        let document = try await dto.getDocument(collectionName: region.rawValue, documentName: uid)
        let data = document.data()
        let decoder = JSONDecoder()
        guard let data = data else { return }
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let activeUser = try decoder.decode(ActiveUser.self, from: jsonData)
        UserManager.shared.activeMyInfo = activeUser
    }
    
    func getActiveUsers(region: Region) async throws -> [ActiveUser]? {
        let documents = try await dto.getDocuments(collectionName: region.rawValue)
        let decoder = JSONDecoder()
        var users = [ActiveUser]()
        
        for document in documents {
            let data = document.data()
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let activeUser = try decoder.decode(ActiveUser.self, from: jsonData)
            users.append(activeUser)
        }
        return users
    }
    
    func setRegionListener(region: Region) -> ListenerRegistration {
        return dto.setListener(collectionName: region.rawValue, listenderAction: { query, error in
            if error != nil {
                print(error, "Set Region Listener Error")
                return
            }
            
            guard let query = query else { return }
            
            let decoder = JSONDecoder()
            for documentChange in query.documentChanges {
                let document = documentChange.document
                let data = document.data()
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let activeUser = try decoder.decode(ActiveUser.self, from: jsonData)
                    if UserManager.shared.activeUsers[activeUser.region] == nil {
                        UserManager.shared.activeUsers[activeUser.region] = [activeUser]
                    } else {
                        UserManager.shared.activeUsers[activeUser.region]?.append(activeUser)
                    }
                } catch {
                    print("Active User Decode Fail")
                }
            }
            
        })
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
    
    func getDocument(collectionName: String, documentName: String) async throws -> DocumentSnapshot {
        return try await database.collection(collectionName).document(documentName).getDocument()
    }
    
    func setListener(collectionName: String, listenderAction: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration {
        return database.collection(collectionName).addSnapshotListener(listenderAction)
    }
}
