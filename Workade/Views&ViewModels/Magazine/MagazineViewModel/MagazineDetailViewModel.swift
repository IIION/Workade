//
//  MagazineDetailViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/04.
//

import UIKit

@MainActor
class MagazineDetailViewModel {
    var magazineData = MagazineResource()
    
    var data: Binder<[MagazineDetailModel]> = Binder([])
    
    init() {
        bindingBookmarkManager()
    }
    
    // Magazine의 전체 내용을 가져오는 함수
    func requestMagazineData() {
        Task {
            do {
                magazineData = try await NetworkManager.shared.requestResourceData(from: Constants.Address.magazineResource)
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    func requestMagazineDetailData(from urlString: String) {
        Task {
            do {
                let detailResource: MagazineDetailResource = try await NetworkManager.shared.requestResourceData(from: urlString)
                data.value = detailResource.content
            } catch {
                let error = error as? NetworkError ?? .unknownError
                print(error.message)
            }
        }
    }
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        BookmarkManager.shared.clickedMagazineId.bind(at: .magazine) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        BookmarkManager.shared.notifyClickedMagazineId(title: id, key: key)
    }
    
    deinit {
        BookmarkManager.shared.clickedMagazineId.remove(at: .magazine)
    }
}
