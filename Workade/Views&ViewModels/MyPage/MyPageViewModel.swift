//
//  MyPageViewModel.swift
//  Workade
//
//  Created by Hyeonsoo Kim on 2022/10/27.
//

import Foundation

@MainActor
final class MyPageViewModel {
    private let bookmarkManager = BookmarkManager.shared
    private let userDefaultsManager = UserDefaultsManager.shared
    var wishMagazines: [MagazineModel] = []
    
    /// 모델 데이터 fetch가 완료되었을 때, HomeViewController에 알려주는 역할을 할 Binder 타입의 변수
    private(set) var isCompleteFetch = Binder(false)
    
    func notifyClickedMagazineId(title id: String, key: String) {
        bookmarkManager.notifyClickedMagazineId(title: id, key: key)
    }
    
    func fetchWishMagazines() {
        Task {
            do {
                guard let resource: MagazineResource = try await NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource) else { return }
                wishMagazines = resource.content.filter {
                    userDefaultsManager.loadUserDefaults(key: Constants.Key.wishMagazine).contains($0.title)
                }
                isCompleteFetch.value = true
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    deinit {
        bookmarkManager.clickedMagazineId.remove(at: .myPage)
    }
}
