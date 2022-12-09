//
//  UserManager.swift
//  Workade
//
//  Created by Inho Choi on 2022/11/30.
//

import Combine
import Foundation

class UserManager {
    private init() {
        Task {
            for region in Region.allCases {
                activeUsers[region] = try await FirestoreDAO.shared.getActiveUsers(region: region)
            }
        }
    }
    
    static let shared = UserManager()
    
    var user = CurrentValueSubject<User?, Never>(nil)
    
    @Published var activeUsers = [Region: [ActiveUser]]()
    
    @Published var activeMyInfo: ActiveUser? = nil
    
    func reloadActiveUser(region: Region) async throws {
        activeUsers[region] = try await FirestoreDAO.shared.getActiveUsers(region: region)
    }
}
