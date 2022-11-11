//
//  HomeViewModel.swift
//  Workade
//
//  Created by Inho Choi on 2022/10/18.
//

import UIKit

@MainActor
final class HomeViewModel {
    var bookmarkManager = BookmarkManager.shared
    
    var officeResource = OfficeResource()
    var magazineResource = MagazineResource()
    
    /// 모델 데이터 fetch가 완료되었을 때, HomeViewController에 알려주는 역할을 할 Binder 타입의 변수
    var isCompleteFetch = Binder(false)
    
    init() {
        requestHomeData()
        bindingBookmarkManager() // 북마크
    }
    
    private func requestHomeData() {
        Task {
            do {
                async let offices: OfficeResource = NetworkManager.shared.requestResourceData(urlString: Constants.Address.officeResource)
                async let magazines: MagazineResource = NetworkManager.shared.requestResourceData(urlString: Constants.Address.magazineResource)
                (officeResource, magazineResource) = try await (offices, magazines)
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    // MARK: 북마크 Logic in ViewModel (init시에 bindingBookmarkManager()호출)
    
    /// 눌린 북마크의 id를 cell - viewController - viewModel - bookmarkManager 흐름으로 알립니다.
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        bookmarkManager.clickedMagazineId.bindAndFire(at: .home) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    /// ViewController -> ViewModel -> Manager
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
}
