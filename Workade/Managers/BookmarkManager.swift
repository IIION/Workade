//
//  BookmarkManager.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/28.
//

import Foundation

final class BookmarkManager {
    static let shared = BookmarkManager()
    
    var clickedMagazineId = MultiBinder("") // manager - viewModel
    
    // MARK: ViewModels -> Manager
    func notifyClickedMagazineId(title id: String, key: String) {
        clickedMagazineId.value = id
        UserDefaultsManager.shared.updateUserDefaults(id: id, key: key)
    }
}
