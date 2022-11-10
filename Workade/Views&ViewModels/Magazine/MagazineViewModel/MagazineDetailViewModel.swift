//
//  MagazineDetailViewModel.swift
//  Workade
//
//  Created by Hong jeongmin on 2022/11/04.
//

import UIKit

@MainActor
class MagazineDetailViewModel {
    var magazineData = MagazineModel(magazineContent: [])
    
    var data: Binder<[MagazineDetailModel]> = Binder([])
    
    init() {
        bindingBookmarkManager()
    }
    
    // Magazine의 전체 내용을 가져오는 함수
    func fetchData() {
        Task {
            magazineData = try await NetworkManager.shared.requestResourceData(urlString: Constants.magazineResourceAddress)
        }
    }
    
    func fetchMagazine(url: URL?) async {
        var magazineDetailData: [MagazineDetailModel] = []
        
        guard let dataUrl = url else { return }
        
        do {
            let result = try await NetworkManager.shared.request(url: dataUrl)
            let magazineData = try JSONDecoder().decode(MagazineDataModel.self, from: result)
            magazineData.magazineData.forEach { detailData in
                magazineDetailData.append(detailData)
            }
        } catch {
            print(error)
        }
        
        data.value = magazineDetailData
    }
    
    func fetchURL(urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    var clickedMagazineId = Binder("")
    
    /// Manager -> ViewModel -> ViewController
    private func bindingBookmarkManager() {
        BookmarkManager.shared.clickedMagazineId.bindAndFire(at: .magazine) { [weak self] id in
            guard let self = self else { return }
            self.clickedMagazineId.value = id
        }
    }
    
    func notifyClickedMagazineId(title id: String, key: String) {
        BookmarkManager.shared.notifyClickedMagazineId(title: id, key: key)
    }
}
