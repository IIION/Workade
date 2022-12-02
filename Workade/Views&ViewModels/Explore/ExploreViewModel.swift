//
//  ExploreViewModel.swift
//  Workade
//
//  Created by 김예훈 on 2022/11/22.
//

import Foundation

@MainActor
final class ExploreViewModel {
    private let firestoreDAO = FirestoreDAO.shared
    var selectedRegion: Binder<Region?> = Binder(nil)
    
    func getUserCount(region: Region) async -> Int {
        let count = try? await firestoreDAO.getActiveUsersNumber(region: region)
        guard let count = count else { return 0 }
        return count
    }
}
