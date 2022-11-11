//
//  MagazineListViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/10/27.
//

import UIKit

@MainActor
class MagazineViewModel {
    
    var magazineData = MagazineResource()
    var isCompleteFetch = Binder(false)
    
    init() {
        requestMagazineData()
        bindingBookmarkManager()
    }
    
    func requestMagazineData() {
        Task {
            do {
                magazineData = try await NetworkManager.shared.requestResourceData(urlString: Constants.Address.magazineResource)
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
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
