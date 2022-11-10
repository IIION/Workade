//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
class MagazineViewModel {
    
    var magazineData = MagazineResource(content: [])
    
    var isCompleteFetch = Binder(false)
    
    init() {
        fetchData()
        bindingBookmarkManager()
    }
    
    func fetchData() {
        Task {
            magazineData = try await NetworkManager.shared.requestResourceData(urlString: Constants.magazineResourceAddress)
            isCompleteFetch.value = true
        }
    }
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        BookmarkManager.shared.clickedMagazineId.bindAndFire(at: .detail) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        BookmarkManager.shared.notifyClickedMagazineId(title: id, key: key)
    }
}
