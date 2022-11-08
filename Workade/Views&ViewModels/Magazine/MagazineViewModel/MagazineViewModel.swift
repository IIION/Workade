//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
class MagazineViewModel {
    private let networkManager = NetworkingManager.shared
    private let bookmarkManager = BookmarkManager.shared
    
    var magazineData = MagazineModel(magazineContent: [])
    
    var isCompleteFetch = Binder(false)
    
    init() {
        fetchData()
        bindingBookmarkManager()
    }
    
    func fetchData() {
        Task {
            magazineData = try await NetworkManager.shared.fetchHomeData("magazine")
            isCompleteFetch.value = true
        }
    }
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        bookmarkManager.clickedMagazineId.bindAndFire(at: .detail) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
}
